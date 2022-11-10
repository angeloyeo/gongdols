#!/usr/bin/env python
# coding: utf-8

# In[1]:

# RBM 원래 코드 출처: https://github.com/odie2630463/Restricted-Boltzmann-Machines-in-pytorch

import numpy as np
import torch
import torch.utils.data
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
from torch.autograd import Variable
from torchvision import datasets, transforms
from torchvision.utils import make_grid , save_image


#%% 시각화를 위해 필요한 함수


# get_ipython().run_line_magic('matplotlib', 'inline')
import matplotlib.pyplot as plt

def show_adn_save(file_name,img):
    npimg = np.transpose(img.numpy(),(1,2,0))
    f = "./%s.png" % file_name
    plt.imshow(npimg)
    plt.imsave(f,npimg)


#%% 잡음 넣어주는 함수
def add_noise(img):
    noise = torch.rand(img.size()) * 0.1
    noisy_img = img + noise
    return noisy_img


#%% RBM 모듈 만들기

class RBM(nn.Module):
    def __init__(self,
                 n_vis=784,
                 n_hin=500,
                 k=5):
        super(RBM, self).__init__()
        self.W = nn.Parameter(torch.randn(n_hin,n_vis)*1e-2)
        self.v_bias = nn.Parameter(torch.zeros(n_vis))
        self.h_bias = nn.Parameter(torch.zeros(n_hin))
        self.k = k
    
    def sample_from_p(self,p):
        p_ = p - Variable(torch.rand(p.size()))
        p_sign = torch.sign(p_)
        return F.relu(p_sign)
    
    def v_to_h(self,v):
        p_h = torch.sigmoid(F.linear(v,self.W,self.h_bias))
        sample_h = self.sample_from_p(p_h)
        return p_h,sample_h
    
    def h_to_v(self,h):
        p_v = torch.sigmoid(F.linear(h,self.W.t(),self.v_bias))
        sample_v = self.sample_from_p(p_v)
        return p_v,sample_v
        
    def forward(self,v):
        pre_h1,h1 = self.v_to_h(v)
        
        h_ = h1
        for _ in range(self.k):
            pre_v_,v_ = self.h_to_v(h_)
            pre_h_,h_ = self.v_to_h(v_)
        
        # 아래의 v는 입력으로 들어온 v이고 v_는 sampling으로 얻은 h로부터 다시 획득한 입력형태...
        return v,v_
    
    def free_energy(self,v):
        vbias_term = v.mv(self.v_bias) # mv: matrix - vector product
        wx_b = F.linear(v,self.W,self.h_bias)
        wx_b = torch.clamp(wx_b, -87, 87) # by limbo-wg
        temp = torch.log(
            torch.exp(wx_b) + 1
            )
        hidden_term = torch.sum(temp, dim = 1)
        
        # hidden_term = wx_b.exp().add(1).log().sum(1)
        return (-hidden_term - vbias_term).mean()


#%% 데이터 셋 불러오기: Fashion MNIST 이용

batch_size = 64

trainset = datasets.FashionMNIST(
    root = './.data/',
    train = True,
    download = True,
    transform = transforms.ToTensor()
    )

train_loader = torch.utils.data.DataLoader(
    dataset = trainset,
    batch_size = batch_size,
    shuffle = True
    )

testset = datasets.FashionMNIST(
    root = './.data/',
    train = False,
    download = True,
    transform = transforms.ToTensor()
    )

test_loader = torch.utils.data.DataLoader(
    dataset = testset,
    batch_size = batch_size,
    shuffle = True
    )

#%% RBM 모델 객체 및 최적화 함수 객체 만들기

rbm = RBM(k=1) # CD의 k = 1로 설정
train_op = optim.Adam(rbm.parameters(), 0.005)

# In[7]:

for epoch in range(50):
    loss_ = []
    for _, (data,target) in enumerate(train_loader):
        data = Variable(data.view(-1,784))
        # noisy_data = data + add_noise(data)
        noisy_data = add_noise(data)
        noisy_data = np.clip(noisy_data, 0, 1) # Bernoulli Sampling의 입력으로 넣어주기 위해 0과 1사이의 값만 가지도록.
        sample_data = noisy_data.bernoulli() # RBM의 입력은 0 또는 1의 값만 가져야 함.
        
        v,v1 = rbm(sample_data)
        loss = rbm.free_energy(v) - rbm.free_energy(v1)
        loss_.append(loss.data.item())
        train_op.zero_grad()
        loss.backward()
        train_op.step()
    
    print(np.mean(loss_))


#%% Train 결과 확인

show_adn_save("real",make_grid(v.view(32,1,28,28).data))
show_adn_save("generate",make_grid(v1.view(32,1,28,28).data))

#%% Test 데이터 가져오기

plt.close('all')
sample_data = testset.data[9].view(-1, 28*28)
sample_data = sample_data.type(torch.FloatTensor)/255.

original_x = sample_data[0].bernoulli()
noisy_x = add_noise(original_x)
noisy_x = np.clip(noisy_x, 0, 1).bernoulli()
_, recovered_x = rbm(noisy_x)


# 디노이징 시각화

f, a = plt.subplots(1, 3, figsize = (5, 3))

original_img = np.reshape(original_x.to('cpu').data.detach().numpy(), (28, 28))
noisy_img = np.reshape(noisy_x.to('cpu').data.detach().numpy(), (28, 28))
recovered_img = np.reshape(recovered_x.to('cpu').data.detach().numpy(), (28, 28))

# 원본 사진
a[0].set_title('Original')
a[0].imshow(original_img, cmap = 'gray')

# 오염된 사진
a[1].set_title('Noisy')
a[1].imshow(noisy_img, cmap = 'gray')

# 복원된 사진
a[2].set_title('Recovered')
a[2].imshow(recovered_img, cmap = 'gray')

plt.show()


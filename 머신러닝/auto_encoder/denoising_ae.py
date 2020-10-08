# -*- coding: utf-8 -*-
"""
Created on Mon Oct  5 12:18:24 2020

@author: biosensor1

튜토리얼: 펭귄브로의 3분 딥러닝, 파이토치 맛

noise 포함된 이미지 복원하기 
"""

import torch
import torchvision
import torch.nn.functional as F
from torch import nn, optim
from torchvision import transforms, datasets

import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm
import numpy as np

#%% 잡음 넣어주는 함수
def add_noise(img):
    noise = torch.randn(img.size()) * 0.2
    noisy_img = img + noise
    
    return noisy_img


#%% Hyperparameters

EPOCH = 10
BATCH_SIZE = 64
USE_CUDA = torch.cuda.is_available()
DEVICE = torch.device('cuda' if USE_CUDA else "cpu")
print("Using Device:", DEVICE)

#%% Fashion MNIST 데이터셋 로딩

trainset = datasets.FashionMNIST(
    root = './.data/',
    train = True,
    download = True,
    transform = transforms.ToTensor()
    )

train_loader = torch.utils.data.DataLoader(
    dataset = trainset,
    batch_size = BATCH_SIZE,
    shuffle = True
    )

#%% AE 모듈 정의

class Autoencoder(nn.Module):
    def __init__(self):
        super(Autoencoder, self).__init__()
        self.encoder = nn.Sequential(
            nn.Linear(28 * 28, 128),
            nn.ReLU(),
            nn.Linear(128, 64),
            nn.ReLU(),
            nn.Linear(64, 12),
            nn.ReLU(),
            nn.Linear(12, 3),
            )
        self.decoder = nn.Sequential(
            nn.Linear(3, 12),
            nn.ReLU(),
            nn.Linear(12, 64),
            nn.ReLU(),
            nn.Linear(64, 128),
            nn.ReLU(),
            nn.Linear(128, 28 * 28),
            nn.Sigmoid(),
            )
        
    def forward(self, x):
        encoded = self.encoder(x)
        decoded = self.decoder(encoded)
        return encoded, decoded
    
    
#%% 모델 생성 및 최적화 함수 객체 불러오기
autoencoder = Autoencoder().to(DEVICE)
optimizer = torch.optim.Adam(autoencoder.parameters(), lr = 0.005)
criterion = nn.MSELoss()

#%% 원본 이미지를 시각화하기
view_data = trainset.data[:5].view(-1, 28*28)
view_data = view_data.type(torch.FloatTensor)/255.

#%% 학습 관련 함수 만들기

def train(autoencoder, train_loader):
    autoencoder.train()
    avg_loss = 0
    for step, (x, label) in enumerate(train_loader):
        # x = x + add_noise(x) # 입력에 노이즈 더하기
        x = add_noise(x) # 입력에 노이즈 더하기
        x = x.view(-1, 28*28).to(DEVICE)
        y = x.view(-1, 28*28).to(DEVICE)
        
        label = label.to(DEVICE)
        
        encoded, decoded = autoencoder(x)
        
        loss =criterion(decoded, y)
        
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
        
        avg_loss += loss.item()
        
    return avg_loss / len(train_loader)

        
#%% 학습 시작

for epoch in range(1, EPOCH + 1):
    loss = train(autoencoder, train_loader)
    print("[Epoch {}] loss: {}".format(epoch, loss))
    
    
#%% TestSet 가져오기
    
testset = datasets.FashionMNIST(
    root = './.data/',
    train = False,
    download = True,
    transform = transforms.ToTensor()
    )

sample_data = testset.data[0].view(-1, 28*28)
sample_data = sample_data.type(torch.FloatTensor)/255.

original_x = sample_data[0]
noisy_x = add_noise(original_x).to(DEVICE)
_, recovered_x = autoencoder(noisy_x)

#%% 디노이징 시각화

f, a = plt.subplots(1, 3, figsize = (15, 15))

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


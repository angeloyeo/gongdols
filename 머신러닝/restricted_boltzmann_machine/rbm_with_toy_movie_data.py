#!/usr/bin/env python
# coding: utf-8
"""
RBM 원래 코드 출처: https://github.com/odie2630463/Restricted-Boltzmann-Machines-in-pytorch
공돌이의 수학정리노트 - RBM편

이번 코드에서는 toy data를 이용해 RBM을 학습해보고 RBM의 성질을 확인해보고자 한다.
Toy data의 idea는 은 Edwin Chen의 Introduction to Restricted Boltzmann Machines에서부터 가져왔다.

https://blog.echen.me/2011/07/18/introduction-to-restricted-boltzmann-machines/
"""
import numpy as np
import torch
import torch.utils.data
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
from torch.autograd import Variable
from torchvision import datasets, transforms
from torchvision.utils import make_grid

import matplotlib.pyplot as plt

#%% RBM 모듈 만들기
class RBM(nn.Module):
    def __init__(self,
                 n_vis=6,
                 n_hin=2,
                 k=5):
        super(RBM, self).__init__()
        # 여타 initialization에 비해 이와 같은 방식이 학습이 제일 잘 됨.
        self.W = nn.Parameter(torch.randn(n_hin,n_vis)*1e-2) 
        self.v_bias = nn.Parameter(torch.zeros(n_vis)) # bias는 0으로 초기화.
        self.h_bias = nn.Parameter(torch.zeros(n_hin)) # bias는 0으로 초기화.
        
        self.k = k # Contrastive Divergence의 횟수
    
    def sample_from_p(self,p):
        # Gibbs Sampling 과정
        # 확률 계산 후 uniform distribution으로부터 얻은 값 보다 크면 1, 아니면 -1로 출력하고
        # relu 함수를 이용해 -1로 출력된 값들은 모두 0으로 처리해버림.
        p_ = p - Variable(torch.rand(p.size()))
        p_sign = torch.sign(p_)
        return F.relu(p_sign)
    
    def v_to_h(self,v):
        # 주어진 visible units로부터 hidden unit을 sampling하는 과정
        p_h = torch.sigmoid(F.linear(v,self.W,self.h_bias))
        sample_h = self.sample_from_p(p_h)
        return p_h,sample_h
    
    def h_to_v(self,h):
        # hidden unit의 샘플로부터 visible unit을 다시 복원해보는 과정
        p_v = torch.sigmoid(F.linear(h,self.W.t(),self.v_bias))
        sample_v = self.sample_from_p(p_v)
        return p_v,sample_v
        
    def forward(self,v):
        # RBM에서 forward propagation은 visible -> hidden -> 다시 visible로 
        # hidden unit과 visible unit을 샘플링 하는 과정을 말함.
        pre_h1,h1 = self.v_to_h(v)
        
        h_ = h1
        for _ in range(self.k): # Contrastive Divergence를 k 번 수행함.
            pre_v_,v_ = self.h_to_v(h_)
            pre_h_,h_ = self.v_to_h(v_)
        
        # 아래의 v는 입력으로 들어온 v이고 v_는 sampling으로 얻은 h로부터 다시 획득한 입력 샘플
        return v,v_
    
    def free_energy(self,v):
        # Free Energy 계산
        vbias_term = v.mv(self.v_bias) # mv: matrix - vector product
        wx_b = F.linear(v,self.W,self.h_bias)
        
        temp = torch.log(
            torch.exp(wx_b) + 1
            )
        hidden_term = torch.sum(temp, dim = 1)
        
        return (-hidden_term - vbias_term).mean()


#%% 학습용 데이터
        
training_data = torch.from_numpy(np.array([
        [1, 1, 1, 0, 0, 0],
        [1, 0, 1, 0, 0, 0],
        [1, 1, 1, 0, 0, 0],
        [0, 0, 1, 1, 1, 0],
        [0, 0, 1, 1, 0, 0],
        [0, 0, 1, 1, 1, 0]]
    )).type(torch.float32)

test_data= torch.from_numpy(np.array([[0, 0, 0, 1, 1, 0]])).type(torch.float32)

#%% RBM 모델 객체 및 최적화 함수 객체 만들기

rbm = RBM(k=1) # CD의 k = 1로 설정. 
# 즉, visible unit을 딱 한번만 sampling 해주고 
# 그걸로 원래의 visible unit의 데이터와 configuration 비교해서 loss로 삼겠다는 의미.
train_op = optim.Adam(rbm.parameters(), 0.0001) # 어떤 Optimizer를 넣어줘도 무관함.

#%% RBM 학습
loss_history = []
loss_best = 9999

for epoch in range(10000):
    
    v,v1 = rbm(training_data)
    loss = rbm.free_energy(v) - rbm.free_energy(v1)
    loss_history.append(loss.data.item())
    train_op.zero_grad()
    loss.backward() # RBM의 Backpropagation은 원래의 입력과 sampling 된 입력간의 차이를 줄여주는 과정
    train_op.step()

    if loss < loss_best:
        rbm_W = rbm.W
        rbm_v_bias = rbm.v_bias
        rbm_h_bias = rbm.h_bias
        print(loss.data.item())
        loss_best = loss
        

plt.plot(loss_history)

rbm.W = rbm_W
rbm.v_bias = rbm_v_bias
rbm.h_bias = rbm_h_bias

#%% Test data 입력
    
rbm.eval()
rbm.v_to_h(test_data)

# 생각한대로 안나오네;

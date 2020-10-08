# -*- coding: utf-8 -*-
"""
Created on Mon Oct  5 12:18:24 2020

@author: biosensor1

튜토리얼: 펭귄브로의 3분 딥러닝, 파이토치 맛
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
    for step, (x, label) in enumerate(train_loader):
        x = x.view(-1, 28*28).to(DEVICE)
        y = x.view(-1, 28*28).to(DEVICE)
        
        label = label.to(DEVICE)
        
        encoded, decoded = autoencoder(x)
        
        loss =criterion(decoded, y)
        
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
        
#%% 학습 시작

for epoch in range(1, EPOCH + 1):
    train(autoencoder, train_loader)
    
    # 디코더에서 나온 이미지를 시각화하기
    
    test_x = view_data.to(DEVICE)
    _, decoded_data = autoencoder(test_x)

    # 원본 이미지와 디코딩 결과 비교해보기
    f, a = plt.subplots(2, 5, figsize = (5, 2))
    print("[Epoch {}]".format(epoch))
    for i in range(5):
        img = np.reshape(view_data.data.numpy()[i], (28, 28))
        a[0][i].imshow(img, cmap = 'gray')
        a[0][i].set_xticks(())
        a[0][i].set_yticks(())
    
    for i in range(5):
        img = np.reshape(decoded_data.to("cpu").detach().numpy()[i], (28, 28))
        a[1][i].imshow(img, cmap = 'gray')
        a[1][i].set_xticks(())
        a[1][i].set_yticks(())
    
    plt.show()
        

#%% 잠재변수 들여다보기
    
view_data = trainset.data[:200].view(-1, 28*28)
view_data = view_data.type(torch.FloatTensor)/255.

test_x = view_data.to(DEVICE)
encoded_data, _ = autoencoder(test_x)
encoded_data = encoded_data.to('cpu')

CLASSES = {
    0: 'T-shirt/Top',
    1: 'Trouser',
    2: 'Pullover',
    3: 'Dress',
    4: 'Coat',
    5: 'Sandal',
    6: 'Shirt',
    7: 'Sneaker',
    8: 'Bag',
    9: 'Ankle boot'
    }

fig = plt.figure(figsize = (10, 8))
ax =Axes3D(fig)

X = encoded_data.data[:, 0].detach().numpy()
Y = encoded_data.data[:, 1].detach().numpy()
Z = encoded_data.data[:, 2].detach().numpy()

labels = trainset.targets[:200].numpy()


for x, y, z, s in zip(X, Y, Z, labels):
    name = CLASSES[s]
    color = cm.rainbow(int(255 * s/9))
    ax.text(x, y, z, name, backgroundcolor = color)
    
ax.set_xlim(X.min(), X.max())
ax.set_ylim(Y.min(), Y.max())
ax.set_zlim(Z.min(), Z.max())

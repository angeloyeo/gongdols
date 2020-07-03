# -*- coding: utf-8 -*-
"""
Created on Fri Jul  3 11:52:09 2020

@author: biosensor1
"""

# from skimage.data import camera
from skimage.filters import frangi
from PIL import Image
import numpy as np
import matplotlib.pyplot as plt

# image = camera()
image = np.asarray(Image.open('vessel.png'))
plt.close('all')

fig, ax = plt.subplots(ncols=2)

ax[0].imshow(image, cmap=plt.cm.gray)
ax[0].set_title('Original image')

ax[1].imshow(
    frangi(image),
    cmap=plt.cm.gray, vmin = 0, vmax = 0.00001)
ax[1].set_title('Frangi filter result')

for a in ax:
    a.axis('off')
plt.tight_layout()
plt.show()

#%% Hessian의 Eigen value만 plot

from skimage.feature import hessian_matrix, hessian_matrix_eigvals

hxx, hxy, hyy = hessian_matrix(image, sigma = 3)

i1, i2 = hessian_matrix_eigvals([hxx, hxy, hyy])

plt.close('all')
fig, ax = plt.subplots(ncols=3)

ax[0].imshow(image, cmap=plt.cm.gray)
ax[0].set_title('Original image')

ax[1].imshow(i1, cmap = plt.cm.gray)
ax[1].set_title('i1')

ax[2].imshow(i2, cmap = plt.cm.gray)
ax[2].set_title('i2')


for a in ax:
    a.axis('off')
plt.tight_layout()
plt.show()
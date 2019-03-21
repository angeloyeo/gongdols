clear; close all; clc;

group1=[10 12 22 15 21];
group2=[22 16 28 23] ;

mwwtest(group1,group2)

ns=4; nb=5;

mu_t=ns*(ns+nb+1)/2;
std_t=sqrt(ns*nb*(ns+nb+1)/12);

T1=17.5; T2=27.5;

Z_T=(T2-mu_t)/std_t
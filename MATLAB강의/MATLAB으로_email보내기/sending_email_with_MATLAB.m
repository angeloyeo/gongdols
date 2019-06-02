clear; close all; clc;
%%
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','E_mail','angeloyeo@gmail.com');
setpref('Internet','SMTP_Username','angeloyeo');
setpref('Internet','SMTP_Password','-');
% https://myaccount.google.com/security 앱 비밀번호를 만들어야 함. 로그인 패스워드가 아니라...

% enabling TLS via port 587
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.port', '587');
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.starttls.enable','true');

sendmail('angeloyeo@gmail.com','Hello from MATLAB!', ...
    'Thanks for using sendmail.');

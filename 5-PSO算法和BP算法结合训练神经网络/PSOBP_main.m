%PSO�㷨�Ż�BP������
%���������MATLAB����ѧ��ģ�е�Ӧ�á�P88
%����������ṹΪ���㣬����PSO�㷨��BP�㷨�Ⱥ�ѵ���������Ȩֵ�ͷ�ֵ�����Ż�����Ľṹ����Ȼ��ƽ�һ������
%����������������ΪPSOBP502.m
%�������ܳ���������ϴ�Լ����10���ӵ�ʱ��
% function main
clc;
clear all;
close all;

MaxRunningTime=1; %�ò�����Ϊ��ʹ���缯�ɣ��ظ�ѵ��MaxRunningTime��
HiddenUnitNum=12;
rand('state',sum(100*clock)); %rand��������α�������״̬��ͬ�������������һ������������״̬��ͬ
TrainSamIn=-4:0.07:2.5;
TrainSamOut=1.1*(1-TrainSamIn+2*TrainSamIn.^2).*exp(-TrainSamIn.^2/2);
TestSamIn=2:0.04:3;
TestSamOut=1.1*(1-TestSamIn+2*TestSamIn.^2).*exp(-TestSamIn.^2/2);
[xxx,TrainSamNum]=size(TrainSamIn);
[xxx,TestSamNum]=size(TestSamIn);
% for HiddenUnitNum=3:MaxHiddenLayerNode %��������Ԫ�ĸ�������ȡ������ĺ�������
    fprintf('\n the hidden layer node');HiddenUnitNum
    TrainNNOut=[];
    TestNNOut=[];
    for t=1:MaxRunningTime
        fprintf('the current running times is');t
        [NewW1,NewB1,NewW2,NewB2]=PSOTrain(TrainSamIn,TrainSamOut,HiddenUnitNum);
        disp('PSO�㷨ѵ�������������BP�㷨����ѵ�����硭��');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%BP�㷨������ʼ����ע��������PSO����һ��
SamInNum=length(TrainSamIn);
TestSamNum=length(TestSamIn);
InDim=1;
OutDim=1;
%ѧϰ�����������
rand('state',sum(100*clock))
NoiseVar=0.01;
Noise=NoiseVar*randn(1,SamInNum);
SamIn=TrainSamIn;
SamOutNoNoise=TrainSamOut;
SamOut=SamOutNoNoise + Noise;
MaxEpochs=300;      %BP�㷨ѵ������
lr=0.003;           %ѧϰ����
E0=0.0001;          %��С�������
W1=NewW1;
B1=NewB1;
W2=NewW2';
B2=NewB2;
%%%%%%%%ֱ����BP�㷨����ʱ��������ĳ�ʼ��������ʱMaxEpochs=20000ѵ��Ч��ͦ��
% W1=0.2*rand(HiddenUnitNum,InDim)-0.1;          %����㵽����ĳ�ʼȨֵ
% B1=0.2*rand(HiddenUnitNum,1)-0.1;              %���ڵ��ʼ��ֵ
% W2=0.2*rand(OutDim,HiddenUnitNum)-0.1;         %���㵽�����ĳ�ʼȨֵ
% B2=0.2*rand(OutDim,1)-0.1;                     %������ʼ��ֵ
%%%%%%%%
W1Ex=[W1 B1]; %12*2
W2Ex=[W2 B2]; %1*13
SamInEx=[SamIn' ones(SamInNum,1)]'; %2*93
ErrHistory=[];
%���������ʼ�����

for i=1:MaxEpochs
    HiddenOut=logsig(W1Ex*SamInEx);    %12*93��ǰ�漸������Ĵ�������Ϊ����һ���ľ�������
    HiddenOutEx=[HiddenOut' ones(SamInNum,1)]';  %13*93
    NetworkOut=W2Ex*HiddenOutEx;  %1*93
    Error=SamOut-NetworkOut;  %1*93
    %������������һά�����
    SSE=sumsqr(Error);  %ƽ����
    %��¼ÿ��Ȩֵ�������ѵ�����
    ErrHistory=[ErrHistory SSE];
 
    if SSE<E0,break, end    %�����Ӧ��ʽ������־��������ѧϰ��P103
        %���㷴�򴫲����
        Delta2=Error;    %�൱��gi
        Delta1=W2'*Delta2.*HiddenOut.*(1-HiddenOut); %�൱��eh
        %����Ȩֵ������
        dW2Ex=Delta2*HiddenOutEx'; %���������-���Ȩֵ��w_hj�������Ԫ��ֵ����_j
        dW1Ex=Delta1*SamInEx';     %����������-����Ȩֵ��v_ih��������Ԫ��ֵ��r_j
        %Ȩֵ����
        W1Ex=W1Ex+lr*dW1Ex;
        W2Ex=W2Ex+lr*dW2Ex;
        %�������㵽������Ȩֵ
        W2=W2Ex(:,1:HiddenUnitNum);
    
end
    
W2=W2Ex(:,1:HiddenUnitNum);
W1=W1Ex(:,1:InDim);
B1=W1Ex(:,InDim+1);
B2=W2Ex(:,1+HiddenUnitNum); 

TrainHiddenOut=logsig(W1*SamIn+repmat(B1,1,SamInNum));
TrainNNOut=W2*TrainHiddenOut+repmat(B2,1,SamInNum);
TestHiddenOut=logsig(W1*TestSamIn+repmat(B1,1,TestSamNum));
TestNNOut=W2*TestHiddenOut+repmat(B2,1,TestSamNum);

figure(MaxEpochs+1);
hold on;
grid;
h1=plot(SamIn,SamOut); %ѵ���������������
set(h1,'color','r','linestyle','-',...
    'linewidth',2.5,'marker','p','markersize',5);
hold on 
h2=plot(TestSamIn,TestSamOut); %����������ʵ���
set(h2,'color','g','linestyle','--',...
    'linewidth',2.5,'marker','^','markersize',7);
h3=plot(SamIn,TrainNNOut);  %ѵ������������������
set(h3,'color','c','linestyle','-.',...
    'linewidth',2.5,'marker','o','markersize',5);
h4=plot(TestSamIn,TestNNOut); %��������������������
set(h4,'color','m','linestyle',':',...
    'linewidth',2.5,'marker','s','markersize',5);
xlabel('Input x','fontsize',13);ylabel('Output y','fontsize',13);
box on;axis tight;
%title('PSO-BP������������ͼ');
legend('����ѧϰʵ������ֵ','�������ʵ������ֵ',...
    '����ѧϰ�������ֵ','��������������ֵ');
hold off;
    end
% end
fidW1=fopen('W1.txt','a+');fidB1=fopen('B1.txt','a+');
fidW2=fopen('W2.txt','a+');fidB2=fopen('B2.txt','a+');
for i=1:length(W1)
    fprintf(fidW1,'\n %6.5f',W1(i));
end
for i=1:length(B1)
    fprintf(fidB1,'\n %6.5f',B1(i));
end
for i=1:length(W2)
    fprintf(fidW2,'\n %6.5f',W2(i));
end
for i=1:length(B2)
    fprintf(fidB2,'\n %6.5f',B2(i));
end
fclose(fidW1);fclose(fidB1);fclose(fidW2);fclose(fidB2);

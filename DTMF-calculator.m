clc
close all 
clear all

telNu =  input("Telefon Nu : ","s") ;

fs = 8000 ; % ornekleme frekansi
t = 0:1/fs:0.1-1/fs ; % t = [0,0.1-1/fs] , degerler 1/fs ile artacak.
signalTel = [] ; % tel sinyali 
genlik = 0.5 ;

for i = 1:length(telNu) 
    temp = telNu(i) ; 
    switch temp    % fL : dtmf'deki dusuk frekans degerleri , fH : dtmf'deki yuksek frekans degerleri
        case '0'
            fL = 941;
            fH = 1336;
        case '1'
            fL = 697;
            fH = 1209;
        case '2'
            fL = 697;
            fH = 1336;
        case '3'
            fL = 697;
            fH = 1477;
        case '4'
            fL = 770;
            fH = 1209;
        case '5'
            fL = 770;
            fH = 1336;
        case '6'
            fL = 770;
            fH = 1477;
        case '7'
            fL = 852;
            fH = 1209;
        case '8'
            fL = 852;
            fH = 1336;
        case '9'
            fL = 852;
            fH = 1477;
        case '*'
            fL = 941;
            fH = 1209;
        case '#'
            fL = 941;
            fH = 1336;
    end

    tempSignal = sin(2*pi*fL*t) + sin(2*pi*fH*t) ; % 1 tus icin sinyal uretimi
    signalTel = [signalTel,tempSignal] ; % sinyal birlestirilir
    signalTel = [signalTel,zeros(1,0.1*fs)] ; % her tuslamadan sonra 0.1 bekleme suresi 

end

signalTel = signalTel*genlik ; 
audiowrite("05346697013.wav",signalTel,fs) ;

s1 = "05346697013.wav" ;
s2 = "Ornek.wav" ;

[tel1,t1] = dtmfBul(s1) ;

figure("Name","05346697013.wav Stem")
stem(t1,tel1) ;
title("05346697013.wav stem grafigi") ;

figure("Name","05346697013.wav Plot")
plot(t1,tel1) ;
title("05346697013.wav plot grafigi") ;

[tel2,t2] = dtmfBul(s2) ;

figure("Name","Ornek.wav Stem")
stem(t2,tel2) ;
title("Ornek.wav stem grafigi") ;

figure("Name","Ornek.wav Plot")
plot(t2,tel2) ;
title("Ornek.wav plot grafigi") ;


function [tel,t] = dtmfBul(s) 
    
[tel,fs] = audioread(s);

lengthTel = length(tel) ;

tuslar = ['1','2','3';'4','5','6';'7','8','9';'*','0','#']; 

n=11 ; % her iki ornek icin de tel nu uzunlugu
d = floor(lengthTel/n) ; % olusturulan araliklarin uzunlugu

t = 0:1/fs:lengthTel*1/fs-1/fs ;

figure("Name",s) ;
for i = 1:n
    tempTel = tel((i-1)*d+1:i*d); % her dongude d uzunlugunda i. aralik alinir
    ftTel = abs(fft(tempTel,fs)); % fft hesaplamasi

    [~,fL] = max(ftTel(651:950)) ; %tuslanan sesin 650:900 aralıgındaki tepe noktasi
    fL = fL + 650 ;
    
    [~,fH] = max(ftTel(1201:1500)) ; %tuslanan sesin 1200:1500 aralıgındaki tepe noktasi
    fH = fH + 1200 ;

    if fL < 720  % dusuk frekansin tus karsiligina denk gelen satir
        j=1;
    elseif fL < 800
        j=2;
    elseif fL < 900
        j=3;
    else
        j=4;
    end
    
    if fH < 1285  % dusuk frekansin tus karsiligina denk gelen sutun
        k=1;
    elseif fH < 1400
        k=2;
    else 
        k=3;
    end

    telNu(i) = tuslar(j,k) ;
    
    subplot(n,1,i);  % spektrum gosterimi
    plot(ftTel(1:1800));
    title(tuslar(j,k)); 
    
end

disp(s + " Dosyasindaki telefon Numarasi -> " + num2str(telNu) ) ;

end
\mainpage Görevci Belgelendirmesi

\author İsmail Sahillioğlu (Kozmotronik)
\copyright \ref lisans "MIT Lisansı"

\image html assets/gorevci-docs-social-color.png

<!-- \image latex assets/gorevci-docs-social-color.png "Görevci Docs Resmi" -->


### Görevciyi Edinme
Görevciyi edinmenin en kolay yolu, Görevciyi Githubdan clon etmek, sonra
(varsa) uygulamak istediğiniz portun örnek projesini açıp gerekli
değişiklikleri yaparak kullanmaktır. Alternatif olarak kaynak kodunu doğrudan
indirip elle projenize dahil edebilirsiniz.


### Kip Seçimi
Görevci iki farklı kipte kullanılabilir:

- Hafif kip
- Normal kip

Kip, projeye eklenecek *gorevciypl.h* adında bir başlık dosyası içerisinde
`grvCALISMA_KIPI` tanımlanarak seçilir. `grvCALISMA_KIPI` 0 olarak tanımlanırsa
Görevci *Hafif kip*, 1 olarak tanımlanırsa *Normal kip* için yapılandırılacaktır.
Kip olarak *Hafif kip* kullanıldığı durumda programcı, `main` işlevi içinde
görev yönetimini kendisi yapar. Her iki kipin kullanımı port demolarında
örneklendirilecektir.


### Görevler Oluşturma
Bir görevin normal bir C işlevinden pek bir farkı yoktur, yalnızca biraz daha
yapılandırılmıştır ve sürekli çalışması gereken görevler içlerinde bir sonsuz
döngü içerir. Bir görevin temel yapısı şu şekilde olmalıdır:  

```c
char gorev(gorevTutucu_t tutucu) {
    // Görev kapsamında (scope) kullanılacak değişkenler burada tanımlanabilir.
    // Değerini koruması gereken değişkenler "static" niteleyicisiyle
    // tanımlanmalıdır.
    static char karakter;

    // Bir görev ana görev döngüsünden hemen önce her zaman görev yapısına
    // başvuru olarak parametre alan grvBASLA() ile başlamalıdır.
    grvBASLA(tutucu);

    // Buraya bir kereye mahsus çalışacak kodlar. Örneğin bir giriş - çıkış
    // portunu ilkleme veya bir analog ucunu ilkleme kodları gibi. Buradaki
    // kodlar görevin yaşam süresi boyunca yalnızca bir kez çalışacağı için
    // ilklendirme işlemlerini yapmak için idealdir.

    // Bu döngü bir görev bloğunun ana döngüsüdür. for(;;) biçiminde de
    // yazılabilir. Burada sonsuz döngüde kalmalı, kesinlikle break veya return
    // ile döngüden çıkılmamalıdır.
    while(1) {
        // Buraya görev kodları ve bloklayıcı API çağrıları
    }

    // Tüm görev işlevleri görev yapısına başvuru olarak parametre alan
    // grvBITIR() ile sonlanmalıdır. Akış sonsuz döngüden buraya gelmesi
    // görevin bir daha çalışmamasına neden olabilir.
    grvBITIR(tutucu);
}
```


### Görevleri Yönetme
Bir görevin bir olay beklemesi ya da gecikmesi gerekiyorsa CPU' yu boşuna
meşgul etmemek, gerektiğinde beklemesi gereken görevi bloklayıp çalışmaya
hazır başka bir görevin çalışmasını sağlamak Görevcinin temel amaçlarındandır.
Ancak bu mekanizmanın düzgün bir şekilde işlemesi için görev bloğu içerisinde,
klasik super-loop veya state-machine programlama mantığında kullanılan `return`
ve `break` gibi dönüş ve döngü kırma komutları kesinlikle kullanılmamalıdır.
Böyle yapmak görevin düzgün ve beklendiği gibi çalışmamasına neden olur.
Bunun yerine aşağıdaki örnek durumlara uygun düşen API' ler kullanılmalıdır.

#### Bir görevi geciktirme
- `grvGECIK_MS()` - *işletim sistemlerinde `sleep()` işlevlerine benzer*
- `grvKOSULLU_GECIK_MS()` - *işletim sistemlerinde `sleep()` işlevlerine benzer*

#### Bir koşul veya olayın beklenmesi
- `grvKOSUL_BEKLE()`
- `grvBU_KOSULDA_BEKLE()`

#### Verilere erişimde senkronizasyon
- `grvBAYRAK_BEKLE()` - *işletim sistemlerindeki `wait()` işlevlerine benzer*
- `grvBAYRAK_IMLE()` - *işletim sistemlerindeki `signal()` işlevlerine benzer*

#### CPU kontrolünden gönüllü olarak vazgeçme
Bazen bir görev kendi isteğiyle kontrolü çalışmak için bekleyen başka bir
göreve vermek isteyebilir. Böyle bir durumda:
- `grvVAZGEC()` - *işletim sistemlerindeki `yield()` işlevlerine benzer*
- `grvKOSULA_DEK_VAZGEC()`


# SoulHeisters

**Unity ile Gerçek Zamanlı Çok Oyunculu (Multiplayer) Oyun Mimarisi ve Ağ Etkileşim Sistemleri**

**Öğrenci:** Hasan Batuhan KILIÇKAN  
**Öğrenci No:** 23100011013  
**Bölüm:** Bilgisayar Mühendisliği  
**Ders:** Bilgisayar Mühendisliği Uygulama Tasarımı  

---

## 1. Proje Özeti

Bu proje, Unity oyun motoru kullanılarak geliştirilen gerçek zamanlı çok oyunculu bir oyun altyapısı prototipidir. Projede, istemci ve sunucu arasındaki veri akışını daha güvenli ve tutarlı yönetebilmek amacıyla **server-authoritative** mimari yaklaşımı benimsenmiştir.

Çalışmanın temel amacı; oyuncu hareketi, savaş sistemi, sağlık-mana yönetimi, yapay zekâ kontrollü düşmanlar, oyun durumu yönetimi ve ölüm/spectate akışı gibi mekanikleri ağ üzerinde senkronize çalışacak şekilde tasarlamak ve modüler bir altyapı oluşturmaktır.

Bu proje, doğrudan tamamlanmış bir ticari oyun üretmekten çok, çok oyunculu oyun geliştirme süreçlerinde kullanılabilecek teknik bir temel oluşturmayı hedeflemektedir.

---

## 2. Kullanılan Teknolojiler

Projede kullanılan temel teknoloji ve araçlar aşağıda verilmiştir:

- **Unity 2022.3 LTS**
- **C#**
- **Unity Netcode for GameObjects (NGO)**
- **Unity Transport**
- **Cinemachine**
- **DOTween**
- **TextMeshPro**
- **Git / GitHub**
- **ParrelSync**

---

## 3. Temel Sistemler

Projede geliştirilen başlıca sistemler şunlardır:

- Host / Client bağlantı altyapısı
- Oyuncu hareket sistemi
- Kamera kontrol sistemi
- Ağ üzerinden transform ve animasyon senkronizasyonu
- Sağlık (Health) sistemi
- Mana sistemi
- Spell / büyü sistemi
- Bolt, Blink, ArcBurst ve SoulGuard yetenekleri
- Sunucu taraflı hasar uygulama sistemi
- Mob spawn sistemi
- Mob yapay zekâsı (takip, saldırı)
- Match flow / oyun durumu yönetimi
- Death camera sistemi
- Spectate sistemi
- Floating damage number sistemi
- World-space health bar sistemi

---

## 4. Proje Klasör Yapısı

Teslim edilen Unity proje yapısında temel olarak aşağıdaki klasörler bulunmaktadır:

- `Assets/`  
  Oyun sahneleri, scriptler, prefablar, materyaller, efektler ve UI bileşenleri

- `Packages/`  
  Unity paket bilgileri

- `ProjectSettings/`  
  Proje ayarları

> Not: `Library`, `Temp`, `Logs` ve `Obj` klasörleri teslim paketine dahil edilmemiştir.  
> Bu klasörler Unity tarafından yeniden oluşturulabildiği için proje boyutunu gereksiz artırmaktadır.

---

## 5. Projeyi Açma ve Çalıştırma

### Unity Editor ile Çalıştırma

1. Unity Hub üzerinden projeyi açınız.
2. Projenin **Unity 2022.3 LTS** sürümü ile açılması önerilmektedir.
3. Paketler yüklendikten sonra başlangıç sahnesini açınız.
4. Unity Editor üzerinden **Play** modunda projeyi çalıştırınız.

### Build ile Çalıştırma

Teslim paketinde build sürümü bulunuyorsa:

1. `Build/` klasörü içerisindeki `.exe` dosyasını çalıştırınız.
2. Uygulama açıldıktan sonra host/client testleri yapılabilir.

---

## 6. Multiplayer Test Süreci

Projede host-client mantığı kullanılmaktadır. Test için aşağıdaki yöntemlerden biri tercih edilebilir.

### Yöntem 1: İki Ayrı Çalıştırma
- Bir pencere **Host** olarak başlatılır.
- İkinci pencere **Client** olarak bağlanır.

### Yöntem 2: ParrelSync ile Yerel Test
- Aynı bilgisayarda birden fazla Unity editör örneği açılır.
- Ana pencere **Host**, klon pencere ise **Client** olarak çalıştırılır.

> Kritik oyun mantıkları mümkün olduğunca sunucu tarafında çalışacak şekilde tasarlanmıştır.  
> Hasar uygulama, mob davranışı ve maç durumu gibi işlemler server tarafından kontrol edilmektedir.

---

## 7. Oyun İçi Kontroller

| Tuş / Girdi | İşlev |
|------------|-------|
| **W / A / S / D** | Hareket |
| **Shift** | Koşma |
| **Space** | Zıplama |
| **Mouse** | Kamera bakışı |
| **Sağ Tık** | Nişan alma |
| **Sol Tık** | Ateş / büyü kullanımı |
| **1 / 2 / 3 / 4** | Aktif büyü seçimi |

---

## 8. Mimari Yaklaşım

Projede, çok oyunculu oyun geliştirmede sık kullanılan **sunucu yetkili mimari** esas alınmıştır. Bu yaklaşımda istemci tarafı çoğunlukla giriş (input) ve görsel geri bildirim üretirken, oyunun kritik kararları sunucu tarafında doğrulanır.

Bu yapının tercih edilme nedenleri:

- Veri tutarlılığını artırmak
- İstemci taraflı manipülasyon riskini azaltmak
- Ağ üzerindeki oyun durumunu merkezi biçimde yönetmek
- Farklı oyun modları için genişletilebilir bir temel oluşturmak

Bu doğrultuda proje; modüler bileşen yapısı, yeniden kullanılabilir sistemler ve genişletilebilir script organizasyonu gözetilerek geliştirilmiştir.

---

## 9. Bilinen Notlar

- Proje aktif geliştirme sürecindedir.
- Bazı sistemler prototip seviyesinde olup ileride genişletilmeye uygundur.
- Çalışmanın temel odağı, tam bir ticari ürün geliştirmekten çok, çok oyunculu oyun altyapısı oluşturmaktır.
- Test ve hata giderme süreci proje kapsamında devam etmektedir.

---

## 10. GitHub Deposu

Kaynak kod deposu aşağıdaki bağlantıda yer almaktadır:

[https://github.com/llamanh0/SoulHeisters](https://github.com/llamanh0/SoulHeisters)

---

## 11. Teslim Notu

Bu proje, **Bilgisayar Mühendisliği Uygulama Tasarımı** dersi kapsamında hazırlanmıştır. Teslim paketinde proje raporu, kaynak kodlar ve varsa çalıştırılabilir build sürümü yer almaktadır.

# Proje Mimarisi

Bu dokuman, oyun kod yapisinin genel mimarisini ozetler.

## Network Katmani

- `Network/AppNetManager.cs`
  - Host/Client baslatma
  - NetworkManager event'lerini dinler
  - DebugCanvas ac/kapa

- `Network/ClientNetworkTransform.cs`
  - NetworkTransform'tan turemis
  - Client authoritative hareket

- `Network/ClientNetworkAnimator.cs`
  - NetworkAnimator'dan turemis
  - Animasyon sync icin client authoritative

## Player Sistemi

- `Player/Core/PlayerReferences.cs`
  - Oyuncuya ait tum alt bile siklara erisim saglayan hub sinif
  - Input, Locomotion, StateMachine, Visual, Combat, Health, Mana, SpellInventory

- `Player/Core/PlayerStateMachine.cs`
  - Oyuncu durum makinesi
  - Idle, Move, Jump, Fall, Dead state'lerini yonetir

- `Player/Movement/PlayerLocomotion.cs`
  - Karakter hareketi ve kamera kontrolu
  - CharacterController ile yuru, ziplama, dusme
  - Cinemachine ile TPS kamera

- `Player/Combat/PlayerCombat.cs`
  - Spell'lerin server tarafina iletilmesi
  - ServerRpc/ClientRpc ile spell efektlerini dagitir

- `Player/Components/HealthComponent.cs`
  - NetworkVariable ile senkronize saglik
  - IDamageable implementasyonu

- `Player/Components/ManaComponent.cs`
  - NetworkVariable ile mana ve server tarafli regen

- `Player/Spells/...`
  - ISpell arayuzu ve farkli spell implementasyonlari
  - SpellInventory runtime'da aktif spell listesini tutar

## Oyun Durumu ve Sistemler

- `Game/Match/GameStateManager.cs`
  - Oyun dongusu: Waiting, Starting, Playing, MatchEnded
  - Event ile diger sistemleri tetikler

- `Game/Systems/WorldMobManager.cs`
  - GameState'e gore mob spawn/despawn
  - Su an mob prefab'lari kullaniyor

- `Game/Systems/EntityLifecycleSystem.cs`
  - Ortak "olum" sonrasi davranislar (Despawn, ileride loot vs.)

## Combat ve VFX

- `Combat/Projectile/ProjectileController.cs`
  - Server tarafli carpma ve hasar dagitimi
  - Omru bitince kendini Despawn eder

- `Combat/Damage/DamageFeedback.cs`
  - Health degisimini dinler
  - Client'ta damage number spawn eder

- `Combat/Damage/DamageNumber*.cs`
  - Ekranda yuze hasar sayisi gostermek icin

## UI

- `UI/HUD/PlayerHUD.cs`
  - Sahibi oldugu oyuncu icin health/mana bar
- `UI/HUD/SpellSlotUI.cs`
  - Spell cooldown overlay ve yetersiz mana feedback

## Dunya ve AI

- `AI/MobAIController.cs`
  - Mob'un hedef bulup kovalamasi
- `Spawning/MobSpawnPoint.cs`
  - Mob spawn noktasi
- `UI/World/HealthBarUI.cs` + `Billboard.cs`
  - Dunya uzerinde health bar ve kameraya bakmasi
## ✨Weapons On Back (ox_inventory)

Un script FiveM pour **ESX Legacy + ox_inventory** permettant de ranger et sortir ses armes **dans le dos**, avec **animations réalistes**.

## ✨ Fonctionnalités
- Armes visibles sur le dos quand elles ne sont pas en main
- Compatible **ox_inventory**
- Animation quand tu ranges ou sors une arme
- Touche configurable (par défaut **G**)
- Gestion automatique de plusieurs armes
- Position ajustée pour être bien centrée au milieu du dos

 📂 Installation
1. Télécharge le script et place-le dans ton dossier `resources/[scripts]`
2. Assure-toi d’avoir **ox_inventory** installé et fonctionnel
3. Ajoute dans ton `server.cfg` :

## 🎮 Utilisation
- **Appuie sur G** pour ranger l’arme en main → elle se met sur le dos avec une animation.
- **Appuie sur G** sans arme en main → la première arme du dos est reprise en main avec une animation.
- Quand tu **utilises une arme** depuis `ox_inventory`, elle est retirée du dos automatiquement.
- Quand tu **ranges une arme** dans `ox_inventory`, elle se place dans ton dos.

## ⚙️ Configuration
Dans `client.lua`, ajoute les armes que tu veux dans la table `weaponModels` 

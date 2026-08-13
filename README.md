# **Bodots - The B(etter) (G)odots launcher**

**Bodots** is a custom fork of the Godots launcher.
The main goal is to extend the default launcher with features, that might be good to have.

<p align="center">
<img width="812" src="https://github.com/MakovWait/godots/assets/39778897/607ce24b-2c39-4ede-8810-f7c528a496d2">
</p>


This project is currently a Work in Progress (WIP)/Proof of Concept (PoC).

## **Features**
- Global Add-on Management:
  * Share a single set of add-ons across all your project without duplicating files
  * Toggle global add-ons on or off per project with a single click.
- Build-in Plugin Manager:
  * Initialize new projects instantly with GD-Plug pre-configured as your default manager.
  * Automatically detect and synchronize updates to global add-ons.
  * GD-Plug handles dependency downloads automatically, so you don't need to track the `addons/` directory in version control.
- Streamlined Git & LFS Setup
  * pre-configured `.gitignore` and `.gitattributes` designed for Godot and Git LFS.

## **VIP**
- Multi-Project Workspaces
  * Support modular / multi-project game architectures. 

### **Full project manager**
- Add, import, organize, and launch projects.
- Bind specific engine versions to individual projects.
- Launch/edit projects directly with their assigned version.
- Drag & drop `project.godot` or entire project folders.

### **Theming**
- Supports custom themes compatible with Godot’s own theming system.
- Guide: 👉 **[Theming Documentation](.github/assets/THEMING.md)**
![image](https://github.com/MakovWait/godots/blob/main/.github/assets/screenshot3.png)

### **CLI interface**
- Manage projects and versions through the command line.  
  Details: 👉 **[CLI Features](.github/assets/FEATURES.md#cli)**

---

## **License**
MIT License — see `LICENSE.md`.

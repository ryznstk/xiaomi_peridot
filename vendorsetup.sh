#!/bin/bash

# Vendor (fresh clone)
echo "Cloning vendor tree..."
rm -rf vendor/xiaomi/peridot
git clone -b rb https://github.com/ryznstk/proprietary_vendor_xiaomi_peridot.git vendor/xiaomi/peridot

# Kernel source (fresh clone)
echo "Cloning kernel source tree..."
rm -rf kernel/xiaomi/sm8635
git clone --depth 1 https://github.com/ryznstk/android_kernel_xiaomi_sm8635.git kernel/xiaomi/sm8635

rm -rf kernel/xiaomi/sm8635-modules
git clone -b lineage-23.2 --depth 1 https://github.com/LineageOS/android_kernel_xiaomi_sm8635-modules.git kernel/xiaomi/sm8635-modules

rm -rf kernel/xiaomi/sm8635-devicetrees
git clone -b lineage-23.2 --depth 1 https://github.com/LineageOS/android_kernel_xiaomi_sm8635-devicetrees.git kernel/xiaomi/sm8635-devicetrees

# Hardware xiaomi (fresh clone)
echo "Cloning hardware xiaomi source..."
rm -rf hardware/xiaomi
git clone -b ll https://github.com/ryznstk/hardware_xiaomi_los.git hardware/xiaomi

# MiuiCamera device tree (fresh clone)
echo "Cloning MiuiCamera device tree..."
rm -rf device/xiaomi/peridot-miuicamera
git clone -b 17 https://github.com/ryznstk/android_device_xiaomi_peridot-miuicamera.git device/xiaomi/peridot-miuicamera

# MiuiCamera vendor tree (fresh clone)
echo "Cloning MiuiCamera vendor tree..."
rm -rf vendor/xiaomi/peridot-miuicamera
git clone https://gitlab.com/blu96/proprietary_vendor_xiaomi_peridot-miuicamera.git vendor/xiaomi/peridot-miuicamera

# Gamebar
echo "Cloning Gamebar tree..."
rm -rf packages/apps/GameBar
git clone https://github.com/ryznstk/packages_apps_GameBar.git packages/apps/GameBar

rm -rf packages/apps/XiaomiParts

# ViperFX
rm -rf packages/apps/JamesDSPManager
git clone https://github.com/ryznstk/packages_apps_JamesDSPManager.git packages/apps/JamesDSPManager

rm -rf packages/apps/TouchServices
git clone https://github.com/ryznstk/packages_apps_TouchServices.git -b lineage-23.2 packages/apps/TouchServices

#cd vendor/lineage
#git fetch https://github.com/CipherOS/android_vendor_cipher seventeen
#git cherry-pick a139ef86c1d00470092b3160e204dd247416eec5
#croot

# KProfiles (fresh clone)
echo "Cloning KProfiles..."
#rm -rf packages/apps/KProfiles
#git clone https://github.com/ryznstk/packages_apps_KProfiles.git packages/apps/KProfiles

rm -rf packages/apps/NotGameTurbo
git clone https://github.com/ryznstk/android_packages_apps_NotGameTurbo.git packages/apps/NotGameTurbo

rm -rf vendor/custom
git clone -b heptakaideka https://github.com/ShinkaiProject/android_vendor_shinkai.git vendor/custom

cd system/sepolicy
git fetch https://github.com/ryznstk/shinkai_system_sepolicy heptakaideka
git reset --hard FETCH_HEAD
croot

# Patch
info "Applying AV patch for dolby"
cd frameworks/av
git remote add lab https://github.com/peridot-lab/yaap_frameworks_av.git && git fetch lab && git cherry-pick 699ff01 || fatal "frameworks/av patch  not failed!"
info "Patch applied successfully"
croot

rm -rf packages/apps/LunarisDolby
rm -rf packages/apps/DolbyAtmos
git clone https://github.com/unmoved21/packages_apps_LunarisDolby.git packages/apps/LunarisDolby

# Refresh signing keys
if [ -d vendor/lineage-priv/keys ]; then
  echo "Removing existing signing keys..."
  rm -rf vendor/lineage-priv/keys
fi
echo "Cloningfresh signing keys..."
git clone -b los https://github.com/ryznstk/keys.git vendor/lineage-priv/keys

# Always back to root at the end
if command -v croot &>/dev/null; then
  croot
else
  cd "$ANDROID_BUILD_TOP" || true
fi

echo "vendorsetup.sh execution complete."

local LSM = LibStub("LibSharedMedia-3.0") 
local AddOnName = ...
local Path = [[Interface\AddOns\]]..AddOnName..[[\media\]]


LSM:Register('font', 'Gotham Narrow Ultra', Path..[[fonts\Gotham Narrow Ultra.otf]])
LSM:Register('font', 'Avant Garde Bold', Path..[[fonts\ITC Avant Garde Gothic Bold.otf]])
LSM:Register('font', 'Avant Garde Medium', Path..[[fonts\ITC Avant Garde Gothic Medium.otf]])

LSM:Register('font', 'TeX Bold', Path..[[fonts\texgyreadventor-bold.otf]])
LSM:Register('font', 'TeX Bold Italic', Path..[[fonts\texgyreadventor-bolditalic.otf]])
LSM:Register('font', 'TeX Italic', Path..[[fonts\texgyreadventor-italic.otf]])
LSM:Register('font', 'TeX Regular', Path..[[fonts\texgyreadventor-regular.otf]])

LSM:Register('texture', 'ArrowCUSTOM', Path..[[textures\ArrowCUSTOM.tga]])

LSM:Register('statusbar', 'BuiOnePixel', Path..[[textures\BuiOnePixel.tga]])
LSM:Register('statusbar', 'BuiOnePixel2', Path..[[textures\BuiOnePixel2.tga]])
LSM:Register('statusbar', 'BuiOnePixel3', Path..[[textures\BuiOnePixel3.tga]])
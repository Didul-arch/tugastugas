import cv2
import matplotlib.pyplot as plt
import numpy as np

# Load gambar
img = cv2.imread('tomato.jpeg')
rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
h, s, v = cv2.split(hsv)

# Tampilkan original
plt.figure(figsize=(4, 4))
plt.imshow(rgb)
plt.title('Original')
plt.axis('off')
plt.show()

# Tampilkan channel HSV dan histogram
fig, axes = plt.subplots(2, 3, figsize=(15, 7))
for i, (ch, name) in enumerate(zip([h, s, v], ['H', 'S', 'V'])):
    axes[0, i].imshow(ch, cmap='gray')
    axes[0, i].set_title(f'Channel {name}')
    axes[0, i].axis('off')
    axes[1, i].hist(ch.ravel(), bins=256, range=[0, 256], color='black')
    axes[1, i].set_title(f'Histogram {name}')
plt.tight_layout()
plt.show()

# Thresholding HSV
mask1 = cv2.inRange(hsv, np.array([0, 27, 40]), np.array([15, 255, 255]))
mask2 = cv2.inRange(hsv, np.array([165, 27, 40]), np.array([179, 255, 255]))
binary = cv2.bitwise_or(mask1, mask2)

# Erosi dan dilasi
k_erosi = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (3, 3))
k_dilasi = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (5, 5))
erosi = cv2.erode(binary, k_erosi)
dilasi = cv2.dilate(erosi, k_dilasi)
hasil = cv2.bitwise_and(rgb, rgb, mask=dilasi)

# Tampilkan pipeline segmentasi
fig, axes = plt.subplots(1, 4, figsize=(16, 4))
for i, (im, t) in enumerate(zip(
    [binary, erosi, dilasi, hasil],
    ['Binary', 'Erosi 3x3', 'Dilasi 5x5', 'Hasil Segmentasi']
)):
    axes[i].imshow(im, cmap='gray' if i < 3 else None)
    axes[i].set_title(t)
    axes[i].axis('off')
plt.tight_layout()
plt.show()

# Variasi ukuran kernel dan iterasi
configs = [
    (3, 3, 1, 1),
    (3, 5, 1, 1),   # pilihan akhir
    (5, 5, 1, 1),
    (5, 7, 1, 1),
    (3, 5, 2, 1),
    (3, 5, 1, 2),
]

fig, axes = plt.subplots(len(configs), 4, figsize=(16, 3.5 * len(configs)))
for row, (ke_s, kd_s, ie, id_) in enumerate(configs):
    ke = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (ke_s, ke_s))
    kd = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (kd_s, kd_s))
    er = cv2.erode(binary, ke, iterations=ie)
    dl = cv2.dilate(er, kd, iterations=id_)
    seg = cv2.bitwise_and(rgb, rgb, mask=dl)
    for col, (im, ttl) in enumerate(zip(
        [binary, er, dl, seg],
        ['Binary', f'Erosi {ke_s}x{ke_s} i={ie}', f'Dilasi {kd_s}x{kd_s} i={id_}', 'Hasil']
    )):
        axes[row, col].imshow(im, cmap='gray' if col < 3 else None)
        axes[row, col].set_title(ttl, fontsize=10)
        axes[row, col].axis('off')
plt.tight_layout()
plt.show()

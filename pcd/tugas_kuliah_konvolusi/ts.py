import numpy as np
import matplotlib.pyplot as plt
from scipy import signal, ndimage
import cv2
import os

# --- 1. SETUP PATH & DATA ---
path_to_images = "./data/train/"
images = [
    'apple-scab.JPG', 
    'grape-blackrot.JPG', 
    'peach-bacterialspot.JPG', 
    'soybean-healthy.JPG', 
    'tomato-leafmold.JPG'
]

# Pastikan folder assets ada untuk menyimpan hasil
output_dir = "./assets"
if not os.path.exists(output_dir):
    os.makedirs(output_dir)

# --- 2. DEFINISI KERNEL ---

# a. Low-pass: Gaussian 5x5 (Sigma = 1)
gaussian_kernel = np.zeros((5, 5))
gaussian_kernel[2, 2] = 1
gaussian_kernel = ndimage.gaussian_filter(gaussian_kernel, sigma=1)

# b. High-pass: Laplacian 8-tetangga
laplacian_kernel = np.array([
    [-1, -1, -1],
    [-1,  8, -1],
    [-1, -1, -1]
])

# c. Deteksi Tepi: Sobel X & Y
sobel_x_kernel = np.array([
    [-1, 0, 1],
    [-2, 0, 2],
    [-1, 0, 1]
])

sobel_y_kernel = np.array([
    [-1, -2, -1],
    [ 0,  0,  0],
    [ 1,  2,  1]
])

# --- 3. PROSES & VISUALISASI ---

print(f"Memulai pemrosesan {len(images)} citra...")

for i, img_name in enumerate(images):
    full_path = os.path.join(path_to_images, img_name)
    img_bgr = cv2.imread(full_path)
    
    if img_bgr is None:
        print(f"Gagal membaca gambar: {img_name}. Lewati...")
        continue

    # --- Preprocessing ---
    img_gray = cv2.cvtColor(img_bgr, cv2.COLOR_BGR2GRAY)
    img_resized = cv2.resize(img_gray, (256, 256))
    img_now = img_resized / 255.0  # Normalisasi [0, 1]

    # --- Konvolusi ---
    res_gaussian = signal.convolve2d(img_now, gaussian_kernel, mode='same')
    res_laplacian = signal.convolve2d(img_now, laplacian_kernel, mode='same')
    res_sobel_x = signal.convolve2d(img_now, sobel_x_kernel, mode='same')
    res_sobel_y = signal.convolve2d(img_now, sobel_y_kernel, mode='same')
    
    # Hitung Magnitudo Gradien (G = sqrt(Gx^2 + Gy^2))
    res_sobel_mag = np.sqrt(res_sobel_x**2 + res_sobel_y**2)

    # --- Plotting (Subplot 2x3) ---
    fig, axes = plt.subplots(2, 3, figsize=(15, 10))
    fig.suptitle(f"Hasil Konvolusi untuk: {img_name}", fontsize=16, fontweight='bold', y=0.95)

    # Baris 1
    axes[0, 0].imshow(img_now, cmap='gray')
    axes[0, 0].set_title('Citra Asli (Grayscale)', fontsize=11)
    
    axes[0, 1].imshow(res_gaussian, cmap='gray')
    axes[0, 1].set_title('Gaussian 5x5 (Low-pass)', fontsize=11)
    
    axes[0, 2].imshow(res_laplacian, cmap='gray')
    axes[0, 2].set_title('Laplacian 8-tetangga (High-pass)', fontsize=11)

    # Baris 2
    axes[1, 0].imshow(res_sobel_x, cmap='gray')
    axes[1, 0].set_title('Sobel X (Vertikal)', fontsize=11)
    
    axes[1, 1].imshow(res_sobel_y, cmap='gray')
    axes[1, 1].set_title('Sobel Y (Horizontal)', fontsize=11)
    
    axes[1, 2].imshow(res_sobel_mag, cmap='gray')
    axes[1, 2].set_title('Sobel Magnitudo (Total Edge)', fontsize=11)

    # Hilangkan sumbu koordinat agar rapi
    for ax in axes.ravel():
        ax.axis('off')

    plt.tight_layout(rect=[0, 0.03, 1, 0.95])

    # --- Simpan Hasil ---
    save_filename = f"result_{img_name.split('.')[0]}.png"
    save_path = os.path.join(output_dir, save_filename)
    plt.savefig(save_path, dpi=300, bbox_inches='tight')
    print(f"[{i+1}/{len(images)}] Berhasil menyimpan: {save_filename}")

    # Tampilkan di layar
    plt.show()

print("\nSeluruh proses selesai. Gambar tersedia di folder ./assets/")
## **🎯 ALUR 1: Buat 1 Asset dengan Upload Data Matrix & Asset Images (2 Request Terpisah)**

### **Karakteristik:**
- Asset baru pertama kali
- Punya foto fisik produk untuk di-upload
- **2 request terpisah**: create asset + upload images

---

### **REQUEST 1: Create Asset + Upload Data Matrix**

**API Endpoint:**
```
POST /assets
Content-Type: multipart/form-data
```

**Form Fields:**
```javascript
{
  // Multipart file
  "dataMatrixImage": <FILE>,  // Opsional, max 10MB

  // JSON fields
  "assetTag": "LAPTOP-00001",
  "assetName": "MacBook Pro 16 M3 Max",
  "categoryId": "01HQX...",
  "brand": "Apple",
  "model": "M3 Max",
  "serialNumber": "SERIAL123",
  "purchaseDate": "2026-01-10",
  "purchasePrice": 35000000,
  "status": "Active",
  "condition": "Good",
  "locationId": "01LOC...",
  "assignedTo": null
}
```

**Response:**
```json
{
  "status": "success",
  "message": "Asset created successfully",
  "data": {
    "id": "01ASSET123",
    "assetTag": "LAPTOP-00001",
    "dataMatrixImageUrl": "https://cloudinary.com/.../sigma-asset/datamatrix/LAPTOP-00001_01ULID.jpg",
    "assetName": "MacBook Pro 16 M3 Max",
    "categoryId": "01HQX...",
    "brand": "Apple",
    "model": "M3 Max",
    "images": [],  // Kosong dulu, belum ada asset images
    "createdAt": "2026-01-11T10:00:00Z"
  }
}
```

---

### **REQUEST 2: Upload Asset Images (Setelah Asset Dibuat)**

**API Endpoint:**
```
POST /assets/upload/bulk-images
Content-Type: multipart/form-data
```

**Form Fields:**
```javascript
{
  "assetImages": [<FILE1>, <FILE2>, <FILE3>],  // Array of files, max 10MB each
  "assetIds": ["01ASSET123", "01ASSET123", "01ASSET123"]  // Same asset ID repeated
}
```

**Detail:**
- Field `assetImages`: Array file gambar (depan, belakang, samping)
- Field `assetIds`: Array ID asset (diulang sejumlah file)
- Jumlah file harus sama dengan jumlah assetIds
- Gambar pertama jadi **primary image** otomatis

**Response:**
```json
{
  "status": "success",
  "message": "Bulk asset images uploaded successfully",
  "data": {
    "results": [
      {
        "assetId": "01ASSET123",
        "imageUrl": "https://cloudinary.com/.../sigma-asset/assets/img1.jpg",
        "success": true
      },
      {
        "assetId": "01ASSET123",
        "imageUrl": "https://cloudinary.com/.../sigma-asset/assets/img2.jpg",
        "success": true
      },
      {
        "assetId": "01ASSET123",
        "imageUrl": "https://cloudinary.com/.../sigma-asset/assets/img3.jpg",
        "success": true
      }
    ],
    "count": 3
  }
}
```

---

## **🎯 ALUR 2: Buat 1 Asset dengan Reuse Images (1 Request)**

### **Karakteristik:**
- Asset sejenis sudah ada di sistem
- Gambar produk sudah tersedia di pool
- **1 request aja** (create asset dengan imageUrls)

---

### **PERSIAPAN: Cek Gambar yang Tersedia**

**API Endpoint:**
```
GET /assets/images?limit=20&cursor=
```

**Query Parameters:**
- `limit`: Jumlah gambar per halaman (max 100)
- `cursor`: ID gambar terakhir (untuk next page)

**Response:**
```json
{
  "status": "success",
  "message": "Available images retrieved successfully",
  "data": [
    {
      "id": "01IMG1",
      "imageUrl": "https://cloudinary.com/.../sigma-asset/assets/macbook-front.jpg",
      "createdAt": "2026-01-10T10:00:00Z"
    },
    {
      "id": "01IMG2",
      "imageUrl": "https://cloudinary.com/.../sigma-asset/assets/macbook-back.jpg",
      "createdAt": "2026-01-10T10:01:00Z"
    },
    {
      "id": "01IMG3",
      "imageUrl": "https://cloudinary.com/.../sigma-asset/assets/macbook-side.jpg",
      "createdAt": "2026-01-10T10:02:00Z"
    }
  ],
  "cursor": "01IMG3",
  "hasNextPage": true,
  "limit": 20
}
```

---

### **REQUEST: Create Asset dengan Reuse Images**

**API Endpoint:**
```
POST /assets
Content-Type: application/json
```

**Payload:**
```json
{
  "assetTag": "LAPTOP-00002",
  "assetName": "MacBook Pro 16 M3 Max #2",
  "categoryId": "01HQX...",
  "brand": "Apple",
  "model": "M3 Max",
  "serialNumber": "SERIAL456",
  "dataMatrixImageUrl": "https://cloudinary.com/.../datamatrix/LAPTOP-00002.jpg",
  "imageUrls": [
    "https://cloudinary.com/.../sigma-asset/assets/macbook-front.jpg",
    "https://cloudinary.com/.../sigma-asset/assets/macbook-back.jpg",
    "https://cloudinary.com/.../sigma-asset/assets/macbook-side.jpg"
  ]
}
```

**Detail:**
- Field `imageUrls`: Array URL gambar yang sudah ada (dari GET /assets/images)
- Sistem extract `public_id` dari URL
- Cari gambar di DB, buat junction table
- **Tidak upload file baru!**

**Response:**
```json
{
  "status": "success",
  "message": "Asset created successfully",
  "data": {
    "id": "01ASSET456",
    "assetTag": "LAPTOP-00002",
    "dataMatrixImageUrl": "https://cloudinary.com/.../datamatrix/LAPTOP-00002.jpg",
    "images": [
      {
        "id": "01JUNCTION1",
        "imageUrl": "https://cloudinary.com/.../assets/macbook-front.jpg",
        "displayOrder": 1,
        "isPrimary": true
      },
      {
        "id": "01JUNCTION2",
        "imageUrl": "https://cloudinary.com/.../assets/macbook-back.jpg",
        "displayOrder": 2,
        "isPrimary": false
      },
      {
        "id": "01JUNCTION3",
        "imageUrl": "https://cloudinary.com/.../assets/macbook-side.jpg",
        "displayOrder": 3,
        "isPrimary": false
      }
    ]
  }
}
```

---

## **🎯 ALUR 3: Bulk Create Assets dengan Upload Files (4 Request)**

### **Karakteristik:**
- Import puluhan/ratusan asset sekaligus
- Produk sejenis (brand/model sama)
- Semua asset pakai gambar yang sama
- **4 request terpisah**

---

### **REQUEST 1: Upload Template Images**

**API Endpoint:**
```
POST /assets/upload/template-images
Content-Type: multipart/form-data
```

**Form Fields:**
```javascript
{
  "templateImages": [<FILE1>, <FILE2>, <FILE3>]  // Max 10 files, max 10MB each
}
```

**Detail:**
- Upload 3 gambar produk untuk **semua asset**
- Gambar disimpan ke folder `sigma-asset/assets`
- **Belum di-attach ke asset manapun**

**Response:**
```json
{
  "status": "success",
  "message": "Template images uploaded successfully",
  "data": {
    "imageUrls": [
      "https://cloudinary.com/.../sigma-asset/assets/01ULID1.jpg",
      "https://cloudinary.com/.../sigma-asset/assets/01ULID2.jpg",
      "https://cloudinary.com/.../sigma-asset/assets/01ULID3.jpg"
    ],
    "count": 3
  }
}
```

**💾 SIMPAN URLs ini untuk REQUEST 4!**

---

### **REQUEST 2: Generate Bulk Asset Tags**

**API Endpoint:**
```
POST /assets/generate-bulk-tags
Content-Type: application/json
```

**Payload:**
```json
{
  "categoryId": "01HQX...",
  "quantity": 100
}
```

**Response:**
```json
{
  "status": "success",
  "message": "Bulk asset tags generated successfully",
  "data": {
    "categoryCode": "LAPTOP",
    "lastAssetTag": "LAPTOP-00002",
    "startTag": "LAPTOP-00003",
    "endTag": "LAPTOP-00102",
    "tags": [
      "LAPTOP-00003",
      "LAPTOP-00004",
      "...",
      "LAPTOP-00102"
    ],
    "quantity": 100,
    "startIncrement": 3,
    "endIncrement": 102
  }
}
```

**💾 SIMPAN array `tags` untuk REQUEST 3 & 4!**

---

### **REQUEST 3: Upload Bulk Data Matrix**

**API Endpoint:**
```
POST /assets/upload/bulk-datamatrix
Content-Type: multipart/form-data
```

**Form Fields:**
```javascript
{
  "dataMatrixImages": [<FILE1>, <FILE2>, ..., <FILE100>],  // 100 files, max 10MB each
  "assetTags": [
    "LAPTOP-00003",
    "LAPTOP-00004",
    "...",
    "LAPTOP-00102"
  ]  // 100 tags dari REQUEST 2
}
```

**Detail:**
- Upload 100 QR code (1 per asset, unique)
- Jumlah file harus sama dengan jumlah tags
- Naming otomatis: `LAPTOP-00003_01ULID.jpg`

**Response:**
```json
{
  "status": "success",
  "message": "Bulk data matrix images uploaded successfully",
  "data": {
    "urls": [
      "https://cloudinary.com/.../datamatrix/LAPTOP-00003_01ULID.jpg",
      "https://cloudinary.com/.../datamatrix/LAPTOP-00004_01ULID.jpg",
      "...",
      "https://cloudinary.com/.../datamatrix/LAPTOP-00102_01ULID.jpg"
    ],
    "count": 100,
    "assetTags": ["LAPTOP-00003", "..."]
  }
}
```

**💾 SIMPAN array `urls` untuk REQUEST 4!**

---

### **REQUEST 4: Bulk Create Assets**

**API Endpoint:**
```
POST /assets/bulk
Content-Type: application/json
```

**Payload:**
```json
{
  "assets": [
    {
      "assetTag": "LAPTOP-00003",
      "assetName": "MacBook Pro 16 M3 Max #1",
      "categoryId": "01HQX...",
      "brand": "Apple",
      "model": "M3 Max",
      "serialNumber": "SERIAL001",
      "dataMatrixImageUrl": "https://cloudinary.com/.../datamatrix/LAPTOP-00003_xxx.jpg",
      "imageUrls": [
        "https://cloudinary.com/.../assets/01ULID1.jpg",
        "https://cloudinary.com/.../assets/01ULID2.jpg",
        "https://cloudinary.com/.../assets/01ULID3.jpg"
      ]
    },
    {
      "assetTag": "LAPTOP-00004",
      "assetName": "MacBook Pro 16 M3 Max #2",
      "categoryId": "01HQX...",
      "brand": "Apple",
      "model": "M3 Max",
      "serialNumber": "SERIAL002",
      "dataMatrixImageUrl": "https://cloudinary.com/.../datamatrix/LAPTOP-00004_xxx.jpg",
      "imageUrls": [
        "https://cloudinary.com/.../assets/01ULID1.jpg",
        "https://cloudinary.com/.../assets/01ULID2.jpg",
        "https://cloudinary.com/.../assets/01ULID3.jpg"
      ]
    }
    // ... 98 assets lagi dengan imageUrls SAMA!
  ]
}
```

**Detail:**
- Array 100 asset dengan data berbeda (serial number, dll)
- Field `dataMatrixImageUrl`: dari REQUEST 3 (berbeda per asset)
- Field `imageUrls`: **SAMA untuk semua** (dari REQUEST 1)
- Sistem reuse 3 gambar untuk 100 asset

**Response:**
```json
{
  "status": "success",
  "message": "Assets bulk created successfully",
  "data": {
    "assets": [
      {
        "id": "01ASSET001",
        "assetTag": "LAPTOP-00003",
        "images": [
          {
            "imageUrl": "https://.../assets/01ULID1.jpg",
            "isPrimary": true
          }
        ]
      }
      // ... 99 assets lagi
    ]
  }
}
```

---

## **🎯 ALUR 4: Bulk Create Assets dengan Reuse Images (3 Request)**

### **Karakteristik:**
- Import banyak asset
- Gambar produk **sudah ada** di sistem
- Hemat bandwidth & waktu maksimal
- **3 request** (skip upload template images)

---

### **REQUEST 1: Cek Gambar yang Tersedia**

**API Endpoint:**
```
GET /assets/images?limit=100
```

**Response:** (sama seperti Alur 2)
```json
{
  "data": [
    {
      "id": "01IMG1",
      "imageUrl": "https://cloudinary.com/.../assets/macbook-front.jpg"
    }
  ]
}
```

**💾 PILIH 3 gambar yang cocok, simpan URLs!**

---

### **REQUEST 2: Generate Tags + Upload Data Matrix**

Sama seperti Alur 3 REQUEST 2 & 3.

---

### **REQUEST 3: Bulk Create dengan Reuse**

**API Endpoint:**
```
POST /assets/bulk
Content-Type: application/json
```

**Payload:**
```json
{
  "assets": [
    {
      "assetTag": "LAPTOP-00103",
      "assetName": "MacBook Pro 14 M3 #1",
      "categoryId": "01HQX...",
      "dataMatrixImageUrl": "https://.../datamatrix/LAPTOP-00103.jpg",
      "imageUrls": [
        "https://cloudinary.com/.../assets/existing1.jpg",
        "https://cloudinary.com/.../assets/existing2.jpg",
        "https://cloudinary.com/.../assets/existing3.jpg"
      ]
    }
    // ... 49 assets lagi
  ]
}
```

**Detail:**
- Field `imageUrls`: **Existing URLs** dari GET /assets/images
- **TIDAK upload template images!**
- Sistem reuse gambar yang sudah ada

---

## **📋 RINGKASAN API ENDPOINTS**

| API | Method | Fungsi | Content-Type |
|-----|--------|--------|--------------|
| assets | POST | Create single asset | multipart atau JSON |
| `/assets/bulk` | POST | Bulk create assets | JSON |
| images | GET | List available images | - |
| `/assets/upload/template-images` | POST | Upload shared images | multipart |
| `/assets/upload/bulk-datamatrix` | POST | Upload data matrix bulk | multipart |
| `/assets/upload/bulk-images` | POST | Upload images to assets | multipart |
| `/assets/generate-tag` | POST | Generate 1 tag | JSON |
| `/assets/generate-bulk-tags` | POST | Generate many tags | JSON |

---

## **🔑 KEY POINTS**

1. **Alur 1 = 2 Request Terpisah:**
   - Create asset dulu → dapat asset ID
   - Upload images pakai asset ID

2. **Field `imageUrls` vs Upload File:**
   - `imageUrls`: Array URL (reuse existing)
   - `dataMatrixImage`/`assetImages`/`templateImages`: Upload file baru

3. **Template Images vs Asset Images:**
   - Template: Upload dulu, attach nanti (bulk create)
   - Asset Images: Upload langsung ke asset yang sudah ada

4. **Reuse = Hemat:**
   - 100 asset × 3 gambar = **300 junction records**
   - Storage cuma **3 gambar** (bukan 300!)

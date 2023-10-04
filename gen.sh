#!/bin/bash
# İş akışı
# 
# 1. Görevci git sürümünü (tag) al
# 2. doxygen üret
# 3. latex dizininde make pdf komutunu çalıştır
# 4. make pdf belgelendirmeyi "refman.pdf" dosyasında birleştirir, bu dosyayı şu
# biçimde yeniden adlandır: Görevci-Docs-$VERSION
# 5. PDF dosyayı pdf dizinine taşı
# 6. latex dizinini sil
# 7. PDF indirme bağlantısını ilgili sürüm için index.md dosyasına ekle.

# 1. Görevci git sürümünü al
sonTag=$(git -C ../gorevci tag -l --sort=-creatordate | head -n 1) # Son commit numarasını al
if [ -z $sonTag ]; then
#     Son tag alınamadı, işlemi iptal et ve sıfırdan farklı değer döndür
    exit 1
fi
# Sürüm numarasındaki noktaları alt tirelerle değiştir
sonTagAltTire="${sonTag//./_}"
echo $sonTagAltTire
kokCiktiYolu="docs"
surumCiktiYolu="$kokCiktiYolu/$sonTagAltTire"
# 2. Doxygen üret
VERSION=$sonTag VERSION_PATH=$sonTagAltTire doxygen Doxyfile

# 3. latex dizininde make pdf komutunu çalıştır
cd "$surumCiktiYolu/latex"; make

# 4. Üretilen pdf dosyayı sürüme göre adlandır
dadi="Görevci-Docs-$sonTag.pdf"
mv refman.pdf $dadi

# 5. dosyayı pdf dizinine taşı
cd "$OLDPWD" # docs dizinine geç
mkdir -p "$surumCiktiYolu/pdf"
mv "$surumCiktiYolu/latex/$dadi" "$surumCiktiYolu/pdf"

# 6. latex dizinini içindekilerle birlikte sil
rm -rf "$surumCiktiYolu/latex"

# 7. PDF indirme bağlantısını ilgili sürüm için index.md dosyasına ekle.
if ! grep -q $sonTag "$kokCiktiYolu/index.md"; then
    echo "|**$sonTag**|[html]($sonTagAltTire/html/index.html)|[pdf]($sonTagAltTire/pdf/$dadi)|" >> "$kokCiktiYolu/index.md"
fi

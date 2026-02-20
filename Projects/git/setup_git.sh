#!/bin/bash

# 1. Konfiguracja Git Global
echo "--- Konfiguracja Git Global ---"

# Zapytaj o User Name
read -p "Podaj nazwę użytkownika Git (User Name): " git_user
git config --global user.name "$git_user"

# Zapytaj o Email
read -p "Podaj swój adres email Git: " git_email
git config --global user.email "$git_email"

echo "Zapisano: $(git config --global user.name) | $(git config --global user.email)"
echo "--------------------------------"

# 2. Dodanie funkcji p() do .bashrc
BASHRC="$HOME/.bashrc"
FUNCTION_NAME="p()"

# Sprawdzenie czy funkcja 'p()' już istnieje w pliku
if grep -q "p()" "$BASHRC"; then
    echo "Funkcja p() jest już dodana do $BASHRC. Pomijam."
else
    echo "Dodaję funkcję p() do $BASHRC..."
    
    # Dopisanie bloku kodu na końcu pliku
    cat << 'EOF' >> "$BASHRC"

# Funkcja p: add + commit z datą + push
p() {
    git add . && \
    git commit -m "Update: $(date '+%Y-%m-%d %H:%M:%S')" && \
    git push
}
EOF
    echo "Gotowe! Funkcja p() została dodana."
fi

echo "--------------------------------"
echo "Aby zacząć korzystać z aliasu 'p', wpisz: source ~/.bashrc"

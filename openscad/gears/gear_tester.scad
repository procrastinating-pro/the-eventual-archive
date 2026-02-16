// ==========================================
// 1. KONFIGURACJA TESTERA (Parametry)
// ==========================================
// Moduł
m = 1;  
// Liczba zębów pierwszej zębatki
z1 = 60;         
// Liczba zębów drugiej zębatki
z2 = 30;            

// Średnica trzpienia
s_o = 8;       
// Wysokość trzpienia
h_o = 7;      
// Grubość płyty podstawy
h_p = 5;            

// Szerokość kołnierza (podkładki)
s_po = 2;           
// Wysokość podkładki
h_po = 1;           

// Gładkość okręgów
$fn = 100;          

// ==========================================
// 2. OBLICZENIA GEOMETRYCZNE
// ==========================================
r_z1 = (z1 * m) / 2; 
r_z2 = (z2 * m) / 2; 
r_o  = s_o / 2;      
r_kolnierza = r_o + s_po; 

// Rozstaw osi: suma promieni podziałowych
odleglosc_osiowa = r_z1 + r_z2; 

// Obliczenia pozycji Z (naprawione nazwy bez polskich znaków)
poz_z_podkladki = (h_p / 2) + (h_po / 2);
// Trzpień musi być przesunięty o połowę grubości podstawy + całą podkładkę + połowę swojej wysokości
poz_z_trzpienia = (h_p / 2) + h_po + (h_o / 2);

// ==========================================
// 3. MODUŁ PODSTAWY TESTOWEJ
// ==========================================
module tester_zebatek() {
    
    // --- PŁYTA GŁÓWNA (Podstawa) ---
    hull() {
        translate([0, 0, 0])
            cylinder(h = h_p, r = r_kolnierza, center = true);
        
        translate([odleglosc_osiowa, 0, 0])
            cylinder(h = h_p, r = r_kolnierza, center = true);
    }

    // --- PODKŁADKI DYSTANSOWE ---
    union() {
        translate([0, 0, poz_z_podkladki])
            cylinder(h = h_po, r = r_kolnierza, center = true);

        translate([odleglosc_osiowa, 0, poz_z_podkladki])
            cylinder(h = h_po, r = r_kolnierza, center = true);
    }

    // --- TRZPIENIE (OSIE MONTAŻOWE) ---
    union() {
        translate([0, 0, poz_z_trzpienia])
            cylinder(h = h_o, r = r_o, center = true);

        translate([odleglosc_osiowa, 0, poz_z_trzpienia])
            cylinder(h = h_o, r = r_o, center = true);
    }
}

// ==========================================
// 4. WYWOŁANIE MODELU
// ==========================================
tester_zebatek();
// ==========================================
// PARAMETRY WEJŚCIOWE (UJEDNOLICONE)
// ==========================================
m = 1;                  // Moduł (wielkość zęba)
z = 30;                 // Liczba zębów
grubosc = 10;           // Wysokość całkowita [mm]
otwor_os = 8;           // Średnica otworu na oś [mm]
kat_skosu = 0;          // Kąt pochylenia (DLA PROSTEJ = 0)
liczba_okienek = 5;     // Liczba otworów ulżeniowych
margines = 4.0;         // Grubość ścianek szprych i tarczy
wartosc_sciecia = 0.15; // Szerokość czubka zęba
steps = 20;             // Dokładność krzywej ewolwenty

// Optymalizacja wydajności: F5 = szybko, F6 = precyzyjnie
jakosc = $preview ? 32 : 100;
$fn = jakosc;

// ==========================================
// OBLICZENIA LOGICZNE
// ==========================================
r = (m * z) / 2;
r_b = r * cos(20);            
r_f = r - 1.25 * m;             
r_a = (r + m) - (wartosc_sciecia * 0.8); 
inv_alfa = tan(20) - (20 * PI / 180);
gamma = 90 / z; 
delta = gamma + (inv_alfa * 180 / PI);

// ==========================================
// BUDOWA BRYŁY
// ==========================================
difference() {
    union() {
        cylinder(r = r_f + 0.2, h = grubosc, center = true);
        for (i = [0 : z - 1]) {
            rotate([0, 0, i * (360 / z)])
                linear_extrude(height = grubosc, center = true)
                    profil_zeba_ewolwentowy();
        }
    }
    // Wycięcia pionowe
    cylinder(d = otwor_os, h = grubosc + 2, center = true);
    linear_extrude(height = grubosc + 2, center = true)
        generuj_profil_okienek();
}

// ==========================================
// MODUŁY I FUNKCJE (WSPÓLNE)
// ==========================================
function involute(rb, t) = [rb * (cos(t) + (t * PI / 180) * sin(t)), rb * (sin(t) - (t * PI / 180) * cos(t))];

module profil_zeba_ewolwentowy() {
    t_start = sqrt(max(0, pow(r_f/r_b, 2) - 1)) * 180 / PI;
    t_end   = sqrt(max(0, pow(r_a/r_b, 2) - 1)) * 180 / PI;
    pts_L = [for (i=[0:steps]) 
        let(t = t_start + (t_end - t_start) * (i/steps), p = involute(r_b, t), rx = p[1], ry = p[0]) 
        [ rx * cos(delta) - ry * sin(delta), rx * sin(delta) + ry * cos(delta) ]
    ];
    pts_P = [for (i=[steps:-1:0]) [-pts_L[i][0], pts_L[i][1]]];
    polygon(concat([[0,0]], pts_L, pts_P));
}

module generuj_profil_okienek() {
    r_os = otwor_os / 2;
    r_wew = r_os + margines;     
    r_zew = r_f - margines; 
    if (r_zew > r_wew + 1) {
        for (j = [0 : liczba_okienek - 1]) {
            rotate([0, 0, j * (360 / liczba_okienek)])
            offset(r = 1.2, $fn=20) offset(r = -1.2)
            intersection() {
                difference() { circle(r = r_zew); circle(r = r_wew); }
                kat = (360 / liczba_okienek) - (margines / (r_wew * PI / 180));
                polygon([[0, 0], [r*2*cos(-kat/2), r*2*sin(-kat/2)], [r*2*cos(kat/2), r*2*sin(kat/2)]]);
            }
        }
    }
}
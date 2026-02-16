// ==========================================
// SEKCJA 1: PARAMETRY WEJŚCIOWE
// ==========================================
m = 1;                  // Moduł
z = 30;                 // Liczba zębów
grubosc = 7;			// Wysokość zębatki [mm]
grobosc_warstwy = 0.2;	// Wysokość warstwy wydruku
otwor_os = 8;           // Średnica otworu na oś
kat_skosu = 15;         // Kąt pochylenia zębów (beta)
$fn = 100;              

// Parametry konstrukcyjne
wartosc_sciecia = 0.15; 
margines = 4.0;         
steps = 20;             
liczba_okienek = 5;

// ==========================================
// SEKCJA 2: OBLICZENIA
// ==========================================
r = (m * z) / 2;
// Całkowity twist dla pełnej wysokości
stopnie_skretu = (360 * grubosc * tan(kat_skosu)) / (2 * PI * r);

r_b = r * cos(20);            
r_f = r - 1.25 * m;             
r_a = (r + m) - (wartosc_sciecia * 0.8); 
inv_alfa = tan(20) - (20 * PI / 180);
gamma = 90 / z; 
delta = gamma + (inv_alfa * 180 / PI);

// ==========================================
// SEKCJA 3: BUDOWA BRYŁY
// ==========================================

difference() {
    // 1. SKRĘCONA BRYŁA ZĘBÓW
    linear_extrude(height = grubosc, center = true, twist = stopnie_skretu, grobosc / grobosc_warstwy)
    union() {
        circle(r = r_f + 0.2); // Rdzeń
        for (i = [0 : z - 1]) {
            rotate([0, 0, i * (360 / z)])
                profil_zeba_ewolwentowy();
        }
    }

    // 2. PIONOWY OTWÓR NA OŚ
    cylinder(d = otwor_os, h = grubosc + 2, center = true);

    // 3. PIONOWE OKIENKA TRAPEZOWE
    linear_extrude(height = grubosc + 2, center = true)
        generuj_profil_okienek();
}

// ==========================================
// SEKCJA 4: MODUŁY POMOCNICZE
// ==========================================

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
            offset(r = 1.2, $fn=30) offset(r = -1.2)
            intersection() {
                difference() { circle(r = r_zew); circle(r = r_wew); }
                kat_wyciecia = (360 / liczba_okienek) - (margines / (r_wew * PI / 180));
                polygon([[0, 0], [r_a*2*cos(-kat_wyciecia/2), r_a*2*sin(-kat_wyciecia/2)], [r_a*2*cos(kat_wyciecia/2), r_a*2*sin(kat_wyciecia/2)]]);
            }
        }
    }
}

function involute(rb, t) = [rb * (cos(t) + (t * PI / 180) * sin(t)), rb * (sin(t) - (t * PI / 180) * cos(t))];
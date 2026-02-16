// --- PARAMETRY KONFIGURACYJNE ---
n_teeth = 45;          // Liczba zębów
m_val = 2;             // Moduł
cone_angle = 45;       // Kąt stożka
face_width = 10;       // Szerokość wieńca
bore_side = 5;         // Bok kwadratowego otworu
tooth_width = 3.5;     // Szerokość zęba u podstawy

// --- OBLICZENIA POMOCNICZE ---
pitch_radius = (n_teeth * m_val) / 2;
top_reduction = face_width * tan(cone_angle);
inner_radius = pitch_radius - top_reduction;

// Wykonanie modelu
bevel_gear();

module bevel_gear() {
    difference() {
        union() {
            // Korpus główny
            cylinder(h = face_width, r1 = pitch_radius, r2 = inner_radius, $fn=64);

            // Generowanie zębów w pętli - POPRAWIONE n_teeth
            for (i = [0 : n_teeth - 1]) {
                rotate([0, 0, i * 360 / n_teeth])
                tooth();
            }
        }
        
        // Wycięcie kwadratowego otworu
        translate([0, 0, face_width / 2])
        cube([bore_side, bore_side, face_width + 2], center = true);
    }
}

module tooth() {
    h_val = m_val; 
    scale_f = inner_radius / pitch_radius;

    pts = [
        // Podstawa zęba (Z=0)
        [-tooth_width/2, pitch_radius - h_val, 0],           // 0
        [ tooth_width/2, pitch_radius - h_val, 0],           // 1
        [ tooth_width/4, pitch_radius + h_val, 0],           // 2
        [-tooth_width/4, pitch_radius + h_val, 0],           // 3
        
        // Wierzchołek zęba (Z=face_width)
        [-tooth_width/2 * scale_f, inner_radius - h_val * scale_f, face_width], // 4
        [ tooth_width/2 * scale_f, inner_radius - h_val * scale_f, face_width], // 5
        [ tooth_width/4 * scale_f, inner_radius + h_val * scale_f, face_width], // 6
        [-tooth_width/4 * scale_f, inner_radius + h_val * scale_f, face_width]  // 7
    ];

    // POPRAWIONA KOLEJNOŚĆ WIERZCHOŁKÓW (zamyka bryłę)
    faces = [
        [3, 2, 1, 0],  // dół
        [4, 5, 6, 7],  // góra
        [0, 1, 5, 4],  // tył
        [1, 2, 6, 5],  // bok prawy
        [2, 3, 7, 6],  // przód
        [3, 0, 4, 7]   // bok lewy
    ];

    polyhedron(points = pts, faces = faces);
}
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Honour Store - LOL Hesap Satış</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
    <style>
        :root{ --bg-dark:#0a0a0f; --bg-card:#12121a; --accent:#c89b3c; --accent-dark:#785a28; --text-primary:#f0e6d2; --text-secondary:#a09b8c; }
        body{ background:var(--bg-dark); color:var(--text-primary); font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif; }
        .navbar{ background:rgba(10,10,15,.95)!important; border-bottom:1px solid var(--accent-dark); }
        .hero{ background:linear-gradient(135deg,var(--bg-dark) 0%,#1a1a2e 100%); padding:4rem 0; text-align:center; border-bottom:2px solid var(--accent-dark); }
        .hero-logo{ width:120px; height:120px; border-radius:50%; border:3px solid var(--accent); object-fit:cover; margin-bottom:1rem; }
        .hero h1{ color:var(--accent); font-size:2.8rem; font-weight:900; letter-spacing:2px; }
        .hero p{ color:var(--text-secondary); font-size:1.2rem; }
        .section{padding:3rem 0;}
        .section-title{ color:var(--accent); border-bottom:2px solid var(--accent-dark); display:inline-block; margin-bottom:2rem; }
        .product-card{ background:var(--bg-card); border:1px solid var(--accent-dark); border-radius:12px; overflow:hidden; transition:.3s; height:100%; }
        .product-card:hover{ transform:translateY(-5px); box-shadow:0 10px 30px rgba(200,155,60,.2); }
        .product-banner{ width:100%; height:160px; object-fit:cover; }
        .product-body{padding:1.5rem;}
        .product-price{ color:var(--accent); font-size:1.3rem; font-weight:bold; }
        .btn-stock-out{ background:#3a3a4a; color:#888; border:none; width:100%; padding:.75rem; border-radius:8px; cursor:not-allowed; }
        .stock-badge{ background:#dc3545; color:#fff; padding:.25rem .75rem; border-radius:20px; font-size:.75rem; }
        .why-us{ background:var(--bg-card); border:1px solid var(--accent-dark); border-radius:12px; padding:2rem; height:100%; }
        .footer{ background:var(--bg-card); border-top:1px solid var(--accent-dark); padding:2rem 0; text-align:center; }
        .user-avatar { width: 35px; height: 35px; border-radius: 50%; border: 2px solid var(--accent); object-fit: cover; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark sticky-top">
    <div class="container">
        <a class="navbar-brand" href="#"><img src="honour.png" height="45"></a>
        <div id="auth-section">
            <button onclick="login()" class="btn btn-outline-warning btn-sm">
                <i class="fab fa-discord"></i> Discord ile Giriş
            </button>
        </div>
    </div>
</nav>

<section class="hero">
    <div class="container">
        <img src="honour.png" class="hero-logo">
        <h1>HONOUR STORE</h1>
        <p>Guvenilir League of Legends Hesap Magazasi</p>
    </div>
</section>

<section id="random" class="section">
    <div class="container text-center">
        <h2 class="section-title">HESAPLAR</h2>
        <p>Giriş yaparak tüm özelliklere erişebilirsin.</p>
    </div>
</section>

<footer class="footer">
    <div class="container"><p>2024 Honour Store - Tum haklari saklidir.</p></div>
</footer>

<script>
    // --- SUPABASE AYARLARI ---
    const supabaseUrl = 'YOUR_SUPABASE_URL' 
    const supabaseKey = 'YOUR_SUPABASE_ANON_KEY'
    const supabaseClient = supabase.createClient(supabaseUrl, supabaseKey)

    // --- GİRİŞ FONKSİYONU ---
    async function login() {
        const { error } = await supabaseClient.auth.signInWithOAuth({
            provider: 'discord',
            options: { redirectTo: window.location.origin }
        })
        if (error) alert('Hata: ' + error.message)
    }

    // --- ÇIKIŞ FONKSİYONU ---
    async function logout() {
        await supabaseClient.auth.signOut()
        window.location.reload()
    }

    // --- SESSION KONTROLÜ VE TABLOYA KAYIT ---
    async function checkUser() {
        const { data: { session } } = await supabaseClient.auth.getSession()
        const authSection = document.getElementById('auth-section')

        if (session) {
            const user = session.user
            const avatar = user.user_metadata.avatar_url
            const name = user.user_metadata.full_name

            // Kullanıcı verisini 'profiller' tablosuna kaydet/güncelle
            await supabaseClient.from('profiller').upsert({ 
                id: user.id, 
                username: name, 
                avatarurl: avatar 
            })

            authSection.innerHTML = `
                <div class="d-flex align-items-center bg-dark p-1 rounded-pill border border-secondary">
                    <img src="${avatar}" class="user-avatar me-2">
                    <span class="text-light me-3 d-none d-md-inline" style="font-size:0.85rem;">${name}</span>
                    <button onclick="logout()" class="btn btn-sm btn-danger rounded-pill" style="font-size:0.7rem;">Çıkış</button>
                </div>`
        }
    }

    checkUser()
</script>
</body>
</html>

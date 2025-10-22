<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Happy Paws PetCare — Modern Veterinary & Grooming</title>
    <meta name="description" content="Book appointments, track medical and grooming records, and manage your pet's care with Meranga PetCare." />
    <meta property="og:title" content="Meranga PetCare" />
    <meta property="og:description" content="A modern clinic & grooming experience for pets and their humans." />
    <meta property="og:type" content="website" />

    <!-- EARLY THEME (must be first; matches header’s localStorage key 'theme') -->
    <script>
        (function () {
            try {
                const saved = localStorage.getItem('theme');
                const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
                const shouldDark = saved ? (saved === 'dark') : prefersDark;
                if (shouldDark) document.documentElement.classList.add('dark');
                else document.documentElement.classList.remove('dark');
            } catch (e) {}
        })();
    </script>

    <!-- Fonts + Tailwind -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Sora:wght@400;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: { sans: ['Inter','system-ui','sans-serif'], display: ['Sora','Inter','system-ui','sans-serif'] },
                    colors: {
                        brand: {
                            50:'#effaff',100:'#d7f0ff',200:'#b2e1ff',300:'#84cdff',400:'#53b2ff',
                            500:'#2f97ff',600:'#1679e6',700:'#0f5fba',800:'#0f4c91',900:'#113e75'
                        }
                    },
                    boxShadow: {
                        soft:'0 10px 30px rgba(0,0,0,.06)',
                        glow:'0 0 0 6px rgba(47,151,255,.10)'
                    }
                }
            },
            darkMode: 'class'
        }
    </script>
    <style>
        /* Subtle animated gradient background */
        .bg-grid {
            background-image: radial-gradient(circle at 1px 1px, rgba(16,24,40,.08) 1px, transparent 0);
            background-size: 24px 24px;
            mask-image: radial-gradient(ellipse 70% 60% at 50% -10%, black 40%, transparent 60%);
        }
        .reveal { opacity: 0; transform: translateY(12px); transition: opacity .6s ease, transform .6s ease; }
        .reveal.visible { opacity: 1; transform: translateY(0); }
    </style>
</head>
<body class="antialiased text-slate-800 dark:text-slate-100 bg-white dark:bg-slate-950">

<!-- NAV -->
<%@ include file="/views/common/header.jsp" %>

<!-- HERO -->
<section class="relative overflow-hidden">
    <div class="absolute inset-0 bg-gradient-to-b from-brand-50 via-white to-white dark:from-slate-900 dark:via-slate-950 dark:to-slate-950"></div>
    <div class="absolute inset-0 bg-grid opacity-60 dark:opacity-20"></div>
    <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20 md:py-28">
        <div class="grid md:grid-cols-2 gap-10 items-center">
            <div class="reveal">
        <span class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 shadow-soft text-xs font-medium mb-4">
          <span class="h-2 w-2 rounded-full bg-emerald-500"></span> Trusted by 1,200+ pet owners
        </span>
                <h1 class="font-display text-4xl sm:text-5xl md:text-6xl font-extrabold leading-[1.1] tracking-tight">
                    A smarter way to care for your <span class="text-brand-700">best friend</span>
                </h1>
                <p class="mt-5 text-slate-600 dark:text-slate-300 max-w-xl">
                    Book appointments, track medical & grooming history, and manage pharmacy purchases in one secure place.
                </p>
                <div class="mt-8 flex flex-wrap gap-3">
                    <a href="#booking" class="inline-flex items-center justify-center px-5 py-3 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft">Book an appointment</a>
                    <a href="#features" class="inline-flex items-center justify-center px-5 py-3 rounded-xl border border-slate-300 dark:border-slate-700 hover:shadow-soft">See features</a>
                </div>
                <div class="mt-8 flex items-center gap-6 text-xs text-slate-500 dark:text-slate-400">
                    <div class="flex items-center gap-2"><svg class="h-4 w-4 fill-emerald-500" viewBox="0 0 24 24"><path d="M9 16.2 4.8 12l-1.4 1.4L9 19 21 7l-1.4-1.4z"/></svg> Secure records</div>
                    <div class="flex items-center gap-2"><svg class="h-4 w-4 fill-emerald-500" viewBox="0 0 24 24"><path d="M9 16.2 4.8 12l-1.4 1.4L9 19 21 7l-1.4-1.4z"/></svg> Same-day booking</div>
                    <div class="flex items-center gap-2"><svg class="h-4 w-4 fill-emerald-500" viewBox="0 0 24 24"><path d="M9 16.2 4.8 12l-1.4 1.4L9 19 21 7l-1.4-1.4z"/></svg> 24/7 portal</div>
                </div>
            </div>

            <div class="reveal">
                <div class="relative mx-auto w-full max-w-lg">
                    <div class="absolute -inset-2 rounded-[2rem] bg-gradient-to-tr from-brand-600/30 via-brand-400/20 to-brand-600/30 blur-2xl"></div>
                    <div class="relative rounded-[2rem] bg-white/70 dark:bg-slate-900/60 border border-slate-200/70 dark:border-slate-700 p-6 md:p-8 shadow-soft backdrop-blur">
                        <div class="flex items-center gap-3">
                            <div class="h-10 w-10 rounded-xl bg-brand-600 text-white grid place-items-center shadow-soft">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 24 24" fill="currentColor"><path d="M12 12a5 5 0 1 0 0-10 5 5 0 0 0 0 10Zm-8 9a8 8 0 1 1 16 0H4Z"/></svg>
                            </div>
                            <div><p class="font-semibold">Book your session Today</p></div>
                        </div>
                        <div class="mt-6 grid grid-cols-2 gap-3">
                            <div class="p-4 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900">
                                <p class="text-xs text-slate-500">Medical visits</p>
                                <p class="text-2xl font-bold">2,418</p>
                            </div>
                            <div class="p-4 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900">
                                <p class="text-xs text-slate-500">Grooming sessions</p>
                                <p class="text-2xl font-bold">1,305</p>
                            </div>
                            <div class="col-span-2 p-4 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 flex items-center gap-3">
                                <svg class="h-5 w-5 text-amber-500" viewBox="0 0 24 24" fill="currentColor"><path d="M12 17.27 18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg>
                                <div>
                                    <p class="text-sm font-medium">4.8/5 average rating</p>
                                    <p class="text-xs text-slate-500">From 600+ verified reviews</p>
                                </div>
                            </div>
                        </div>
                        <a href="#booking" class="mt-6 w-full inline-flex items-center justify-center px-4 py-3 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft">Start booking</a>
                    </div>
                </div>
            </div>

        </div>
    </div>
</section>

<!-- FEATURES -->
<section id="features" class="py-20">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="max-w-2xl reveal">
            <h2 class="font-display text-3xl md:text-4xl font-bold">Everything you need in one place</h2>
            <p class="mt-3 text-slate-600 dark:text-slate-300">From appointments to medical records and grooming—Happy Paws PetCare keeps it simple and secure.</p>
        </div>
        <div class="mt-12 grid sm:grid-cols-2 lg:grid-cols-4 gap-6">
            <div class="reveal p-6 rounded-2xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:shadow-soft">
                <div class="h-10 w-10 rounded-lg bg-emerald-100 text-emerald-700 grid place-items-center">
                    <svg class="h-5 w-5" viewBox="0 0 24 24" fill="currentColor"><path d="M6 2h12a2 2 0 0 1 2 2v3H4V4a2 2 0 0 1 2-2Zm14 7H4v9a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9Zm-5 3h4v2h-4v-2Z"/></svg>
                </div>
                <h3 class="mt-4 font-semibold">Smart booking</h3>
                <p class="mt-2 text-sm text-slate-600 dark:text-slate-300">Real-time availability for veterinary & grooming services.</p>
            </div>
            <div class="reveal p-6 rounded-2xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:shadow-soft">
                <div class="h-10 w-10 rounded-lg bg-sky-100 text-sky-700 grid place-items-center">
                    <svg class="h-5 w-5" viewBox="0 0 24 24" fill="currentColor"><path d="M4 7a3 3 0 0 1 3-3h10a3 3 0 0 1 3 3v10a3 3 0 0 1-3 3H7a3 3 0 0 1-3-3V7Zm10 0H7v10h10V7Z"/></svg>
                </div>
                <h3 class="mt-4 font-semibold">Medical records</h3>
                <p class="mt-2 text-sm text-slate-600 dark:text-slate-300">Secure, searchable history with prescriptions and treatments.</p>
            </div>
            <div class="reveal p-6 rounded-2xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:shadow-soft">
                <div class="h-10 w-10 rounded-lg bg-amber-100 text-amber-700 grid place-items-center">
                    <svg class="h-5 w-5" viewBox="0 0 24 24" fill="currentColor"><path d="M20 8h-3l-1-2H8L7 8H4v12h16V8ZM6 10h12v8H6v-8Z"/></svg>
                </div>
                <h3 class="mt-4 font-semibold">Grooming log</h3>
                <p class="mt-2 text-sm text-slate-600 dark:text-slate-300">Track services, notes, and photos after every session.</p>
            </div>
            <div class="reveal p-6 rounded-2xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:shadow-soft">
                <div class="h-10 w-10 rounded-lg bg-fuchsia-100 text-fuchsia-700 grid place-items-center">
                    <svg class="h-5 w-5" viewBox="0 0 24 24" fill="currentColor"><path d="M3 4h18v2H3V4Zm0 7h18v2H3v-2Zm0 7h18v2H3v-2Z"/></svg>
                </div>
                <h3 class="mt-4 font-semibold">Shop & pharmacy</h3>
                <p class="mt-2 text-sm text-slate-600 dark:text-slate-300">Inventory, sales, and low-stock alerts built in.</p>
            </div>
        </div>
    </div>
</section>

<!-- SERVICES / HIGHLIGHTS -->
<section id="services" class="py-20 bg-slate-50 dark:bg-slate-900/40">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid md:grid-cols-2 gap-12 items-center">
            <div class="reveal">
                <img src="https://images.unsplash.com/photo-1548199973-03cce0bbc87b?q=80&w=1200&auto=format&fit=crop" alt="Vet holding a happy dog" class="rounded-3xl shadow-soft border border-slate-200 dark:border-slate-800" />
            </div>
            <div class="reveal">
                <h2 class="font-display text-3xl md:text-4xl font-bold">Compassionate care, modern systems</h2>
                <p class="mt-3 text-slate-600 dark:text-slate-300">Our team blends friendly care with a powerful digital experience—so you spend less time on paperwork and more time with your pet.</p>
                <ul class="mt-6 space-y-3 text-sm">
                    <li class="flex items-start gap-3"><span class="mt-1 h-5 w-5 rounded-full bg-emerald-100 text-emerald-700 grid place-items-center"></span> Same day and weekend availability</li>
                    <li class="flex items-start gap-3"><span class="mt-1 h-5 w-5 rounded-full bg-emerald-100 text-emerald-700 grid place-items-center"></span> Secure owner portal with history</li>
                    <li class="flex items-start gap-3"><span class="mt-1 h-5 w-5 rounded-full bg-emerald-100 text-emerald-700 grid place-items-center"></span> Pharmacy pick-up and subscription refills</li>
                </ul>
                <div class="mt-8 flex gap-3">
                    <a href="#booking" class="inline-flex items-center justify-center px-5 py-3 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft">Book a visit</a>
                    <a href="#contact" class="inline-flex items-center justify-center px-5 py-3 rounded-xl border border-slate-300 dark:border-slate-700">Contact us</a>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- STATS -->
<section id="stats" class="py-20">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 reveal">
        <div class="grid sm:grid-cols-2 lg:grid-cols-4 gap-6 text-center">
            <div class="p-8 rounded-3xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 shadow-soft">
                <p class="text-4xl font-extrabold">12k+</p>
                <p class="mt-1 text-sm text-slate-500">Happy pets cared for</p>
            </div>
            <div class="p-8 rounded-3xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 shadow-soft">
                <p class="text-4xl font-extrabold">4.8/5</p>
                <p class="mt-1 text-sm text-slate-500">Average owner rating</p>
            </div>
            <div class="p-8 rounded-3xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 shadow-soft">
                <p class="text-4xl font-extrabold">2.4k</p>
                <p class="mt-1 text-sm text-slate-500">Monthly clinic visits</p>
            </div>
            <div class="p-8 rounded-3xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 shadow-soft">
                <p class="text-4xl font-extrabold">1.3k</p>
                <p class="mt-1 text-sm text-slate-500">Grooming sessions</p>
            </div>
        </div>
    </div>
</section>

<!-- REVIEWS -->
<section id="reviews" class="py-20 bg-slate-50 dark:bg-slate-900/40">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="max-w-2xl reveal">
            <h2 class="font-display text-3xl md:text-4xl font-bold">Loved by pet parents</h2>
            <p class="mt-3 text-slate-600 dark:text-slate-300">Real stories from our community.</p>
        </div>
        <div class="mt-10 grid md:grid-cols-3 gap-6">
            <figure class="reveal p-6 rounded-2xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 shadow-soft">
                <blockquote class="text-sm text-slate-700 dark:text-slate-200">"Booking was super easy and the vet already had Bella's full history. We were in and out in 20 minutes!"</blockquote>
                <figcaption class="mt-4 text-xs text-slate-500">- John D.</figcaption>
            </figure>
            <figure class="reveal p-6 rounded-2xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 shadow-soft">
                <blockquote class="text-sm text-slate-700 dark:text-slate-200">"The grooming team is wonderful. I love seeing notes & photos after each session."</blockquote>
                <figcaption class="mt-4 text-xs text-slate-500">- Mary S.</figcaption>
            </figure>
            <figure class="reveal p-6 rounded-2xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 shadow-soft">
                <blockquote class="text-sm text-slate-700 dark:text-slate-200">"Finally a clinic where the shop and records live together. Refills are a tap away."</blockquote>
                <figcaption class="mt-4 text-xs text-slate-500">- Kavin K.</figcaption>
            </figure>
        </div>
    </div>
</section>

<!-- CONTACT / FOOTER -->
<%@ include file="/views/common/footer.jsp" %>

<!-- Page-only scripts (no theme toggling here; header handles it) -->
<script>
    // Reveal on scroll
    const observer = new IntersectionObserver(entries => {
        entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
    }, { threshold: 0.08 });
    document.querySelectorAll('.reveal').forEach(el => observer.observe(el));

    // Example handlers (optional; keep if you use them)
    function handleBooking(){
        document.getElementById('bookingMsg')?.classList.remove('hidden');
    }
    function handleSubscribe(){
        const email = document.getElementById('emailSub')?.value || '';
        if(email.includes('@')) document.getElementById('subMsg')?.classList.remove('hidden');
    }

    // Year stamp (if footer has #year)
    document.getElementById('year') && (document.getElementById('year').textContent = new Date().getFullYear());
</script>
</body>
</html>

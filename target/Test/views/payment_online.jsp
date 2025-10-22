<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String c = request.getContextPath();
    String pk = (String) request.getAttribute("publishableKey");
    String clientSecret = (String) request.getAttribute("clientSecret");
    Integer appointmentId = (Integer) request.getAttribute("appointmentId");
    java.math.BigDecimal amount = (java.math.BigDecimal) request.getAttribute("amount");
%>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Secure Payment — Happy Paws</title>
    <meta name="description" content="Pay securely for your appointment."/>
    <script src="https://js.stripe.com/v3/"></script>
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
                        brand: { 50:'#effaff',100:'#d7f0ff',200:'#b2e1ff',300:'#84cdff',400:'#53b2ff',500:'#2f97ff',600:'#1679e6',700:'#0f5fba',800:'#0f4c91',900:'#113e75' }
                    },
                    boxShadow: { soft:'0 10px 30px rgba(0,0,0,.06)', glow:'0 0 0 6px rgba(47,151,255,.10)' }
                }
            },
            darkMode: 'class'
        }
    </script>
    <style>
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

<%@ include file="header.jsp" %>

<!-- HEADER -->
<section class="relative overflow-hidden">
    <div class="absolute inset-0 bg-gradient-to-b from-brand-50 via-white to-white dark:from-slate-900 dark:via-slate-950 dark:to-slate-950"></div>
    <div class="absolute inset-0 bg-grid opacity-60 dark:opacity-20"></div>

    <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 md:py-14">
        <div class="flex items-center justify-between gap-4 reveal">
            <div>
                <h1 class="font-display text-3xl md:text-4xl font-extrabold tracking-tight">Secure Payment</h1>
                <p class="mt-2 text-sm text-slate-600 dark:text-slate-300">Pay to confirm your booking.</p>
            </div>
            <a href="<%= c %>/views/user_appointments.jsp"
               class="inline-flex items-center px-4 py-2 rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 hover:shadow-soft">
                ← Back
            </a>
        </div>
    </div>
</section>

<!-- CONTENT -->
<section class="max-w-xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">
    <div class="reveal relative">
        <div class="absolute -inset-2 rounded-3xl bg-gradient-to-tr from-brand-600/20 via-brand-400/10 to-brand-600/20 blur-2xl"></div>

        <div class="relative rounded-3xl border border-slate-200 dark:border-slate-800 bg-white/80 dark:bg-slate-900/60 p-6 md:p-7 shadow-soft backdrop-blur">
            <div class="p-4 mb-6 rounded-2xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 flex items-center justify-between">
                <span class="text-sm text-slate-600 dark:text-slate-300">Amount due</span>
                <span class="text-xl font-extrabold">Rs <%= amount %></span>
            </div>

            <!-- Separate Stripe fields -->
            <div class="space-y-4">
                <label class="block text-sm font-medium">Card Number</label>
                <div id="card-number" class="rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-3"></div>

                <label class="block text-sm font-medium">Expiry</label>
                <div id="card-expiry" class="rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-3"></div>

                <label class="block text-sm font-medium">CVC</label>
                <div id="card-cvc" class="rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-3"></div>
            </div>

            <div id="msg" class="mt-3 text-sm text-rose-600"></div>

            <div class="mt-6 flex items-center gap-3">
                <button id="payBtn"
                        class="inline-flex items-center px-5 py-2.5 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-medium shadow-soft disabled:opacity-60 disabled:cursor-not-allowed">
                    Pay now
                </button>
                <a href="<%= c %>/views/user_appointments.jsp"
                   class="inline-flex items-center px-4 py-2 rounded-xl border border-slate-200 dark:border-slate-800 hover:shadow-soft">
                    Cancel
                </a>
            </div>
        </div>
    </div>
</section>

<%@ include file="footer.jsp" %>

<script>
    // Reveal
    const observer = new IntersectionObserver(entries => {
        entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
    }, { threshold: 0.08 });
    document.querySelectorAll('.reveal').forEach(el => observer.observe(el));

    // Stripe
    const stripe = Stripe("<%= pk %>");
    const elements = stripe.elements();

    const style = {
        base: { fontSize: '16px', color: '#ffffff', '::placeholder': { color: '#9ca3af' } },
        invalid: { color: '#ef4444' }
    };

    const cardNumber = elements.create('cardNumber', { style });
    cardNumber.mount('#card-number');

    const cardExpiry = elements.create('cardExpiry', { style });
    cardExpiry.mount('#card-expiry');

    const cardCvc = elements.create('cardCvc', { style });
    cardCvc.mount('#card-cvc');

    const payBtn = document.getElementById('payBtn');
    const msg = document.getElementById('msg');

    payBtn.addEventListener('click', async () => {
        msg.textContent = '';
        payBtn.disabled = true;

        const { error, paymentIntent } = await stripe.confirmCardPayment("<%= clientSecret %>", {
            payment_method: { card: cardNumber }
        });

        if (error) {
            msg.textContent = error.message || 'Payment failed. Try again.';
            payBtn.disabled = false;
            return;
        }

        if (paymentIntent && paymentIntent.status === 'succeeded') {
            try {
                const res = await fetch("<%= c %>/pay/online/confirm", {
                    method: 'POST',
                    headers: { 'Content-Type':'application/json' },
                    body: JSON.stringify({ appointmentId: <%= appointmentId %>, paymentIntentId: paymentIntent.id })
                });
                if (res.ok) {
                    window.location = "<%= c %>/pay/success?appointmentId=<%= appointmentId %>";
                } else {
                    msg.textContent = 'Payment succeeded but server update failed.';
                    payBtn.disabled = false;
                }
            } catch (e) {
                msg.textContent = 'Payment succeeded, server error occurred.';
                payBtn.disabled = false;
            }
        }
    });
</script>
</body>
</html>

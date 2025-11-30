/* landing.js
    Handles hero floating leaves, navbar active highlight, scroll reveals,
    impact bar drag behavior, share button, and small CTA micro-animations.
*/

document.addEventListener('DOMContentLoaded', function(){
                    // Remove preload class to allow CSS transitions/visibility to take effect
                    try { document.body.classList.remove('preload'); } catch(e) {}

                    // Debug: log basic diagnostics so we can see if GSAP loaded and how many feature cards exist
                    try{
                        console.debug('[landing.js] DOMContentLoaded — diagnostics:', {
                            gsapLoaded: !!window.gsap,
                            scrollTriggerLoaded: !!window.ScrollTrigger,
                            featureCardCount: document.querySelectorAll('.feature-card').length,
                            circleCardPresent: !!document.querySelector('.circle-card')
                        });
                    } catch(err){ console.debug('[landing.js] diagnostics failed', err); }
            // NAV HIGHLIGHT ON SCROLL
            const sections = Array.from(document.querySelectorAll('section[id]'));

            function onScrollNav(){
                const scrollPos = window.scrollY + (window.innerHeight/4);
                sections.forEach(sec => {
                    const top = sec.offsetTop;
                    const bottom = top + sec.offsetHeight;
                    const id = '#' + sec.id;
                    const link = document.querySelector(`.nav-link[href="${id}"]`);
                    if(!link) return;
                    if(scrollPos >= top && scrollPos < bottom){
                        link.classList.add('active');
                    } else {
                        link.classList.remove('active');
                    }
                });
            }
            window.addEventListener('scroll', onScrollNav);
            onScrollNav();

            // SCROLL-TRIGGERED REVEALS: prefer GSAP + ScrollTrigger when available
            if(window.gsap && window.ScrollTrigger){
                try{
                    gsap.registerPlugin(ScrollTrigger);

                    // Hero reveal
                    gsap.from('.hero-content', {opacity:0, y:24, duration:0.7, ease:'power2.out', scrollTrigger:{trigger:'.hero-content', start:'top 80%'}});

                    // Stagger the four feature cards popping up
                    gsap.from('.features-grid .feature-card', {
                        opacity:0, scale:0.96, y:18, stagger:0.15, duration:0.6, ease:'back.out(1.2)',
                        scrollTrigger: { trigger: '#features', start: 'top 75%' }
                    });

                    // Circle card appears slightly after the four cards
                    gsap.fromTo('.circle-card', {opacity:0, scale:0.6}, {
                        opacity:1, scale:1, duration:0.8, ease:'elastic.out(1,0.6)',
                        scrollTrigger: { trigger: '#features', start:'top 65%', toggleActions: 'play none none none', delay:0.25 }
                    });

                    console.debug('[landing.js] GSAP animations initialized');
                } catch(e){
                    console.error('[landing.js] GSAP initialization error', e);
                }
            } else {
                console.debug('[landing.js] GSAP/ScrollTrigger not detected — using fallback reveal sequence');
                // fallback: when the features section comes into view, stagger reveal the 4 cards, then pop the circle
                const featuresSection = document.getElementById('features');
                const featureCards = Array.from(document.querySelectorAll('.features-grid .feature-card'));
                const circle = document.querySelector('.circle-card');

                if(featuresSection){
                    const obs = new IntersectionObserver((entries, observer) => {
                        entries.forEach(entry => {
                            if(entry.isIntersecting){
                                // stagger reveal: apply .reveal to each card with a small delay
                                featureCards.forEach((card, idx) => {
                                    setTimeout(() => card.classList.add('reveal'), idx * 150);
                                });
                                // after cards, pop the circle
                                const circleDelay = featureCards.length * 150 + 300;
                                if(circle){
                                    setTimeout(()=>{
                                        circle.classList.add('show-circle');
                                        // give it a distinct pop animation class
                                        circle.classList.add('pop');
                                    }, circleDelay);
                                }
                                observer.unobserve(featuresSection);
                            }
                        });
                    }, { threshold: 0.18 });
                    obs.observe(featuresSection);
                } else {
                    // fallback immediate reveal if section not found
                    featureCards.forEach((card, idx) => setTimeout(()=>card.classList.add('reveal'), idx * 150));
                    if(circle) setTimeout(()=>{ circle.classList.add('show-circle'); circle.classList.add('pop'); }, featureCards.length * 150 + 300);
                }
            }

            // HERO LEAVES FLOAT
            const leaves = document.querySelectorAll('.hero-leaves .leaf');
            leaves.forEach((leaf, i) => {
                const delay = (i * 0.8) + Math.random()*1.2;
                leaf.style.animation = `floatLeaf 8s ${delay}s ease-in-out infinite`;
            });

            // CTA micro animations
            const ctas = document.querySelectorAll('.cta-primary, .cta-secondary');
            ctas.forEach(btn => {
                btn.addEventListener('mouseenter', ()=> btn.classList.add('pulse'));
                btn.addEventListener('mouseleave', ()=> btn.classList.remove('pulse'));
            });

            // Impact bar drag/interaction moved here from inline
            (function(){
                const totalTasks = 72;
                const taskBar = document.getElementById('task-bar');
                if(!taskBar) return;
                const taskFill = document.getElementById('task-fill');
                const handle = document.getElementById('task-handle');
                const tasksCompleted = document.getElementById('tasks-completed');
                const co2Value = document.getElementById('co2-value');
                const shareBtn = document.getElementById('share-impact');
                const co2PerTask = 0.45;

                let dragging = false;
                let rect = null;

                function updateFromX(clientX){
                    if(!rect) rect = taskBar.getBoundingClientRect();
                    let x = clientX - rect.left;
                    x = Math.max(0, Math.min(x, rect.width));
                    const ratio = x / rect.width;
                    const completed = Math.round(ratio * totalTasks);
                    const pct = (completed / totalTasks) * 100;
                    taskFill.style.width = pct + '%';
                    handle.style.left = pct + '%';
                    tasksCompleted.textContent = completed;
                    co2Value.textContent = (completed * co2PerTask).toFixed(2);
                }

                function onDown(e){
                    dragging = true; rect = taskBar.getBoundingClientRect();
                    document.body.style.userSelect = 'none';
                    const clientX = (e.touches && e.touches[0]) ? e.touches[0].clientX : e.clientX;
                    updateFromX(clientX);
                }
                function onMove(e){
                    if(!dragging) return;
                    const clientX = (e.touches && e.touches[0]) ? e.touches[0].clientX : e.clientX;
                    updateFromX(clientX);
                }
                function onUp(){ dragging = false; document.body.style.userSelect = ''; rect = null; }

                handle.addEventListener('mousedown', onDown);
                window.addEventListener('mousemove', onMove);
                window.addEventListener('mouseup', onUp);

                handle.addEventListener('touchstart', onDown, {passive:true});
                window.addEventListener('touchmove', onMove, {passive:true});
                window.addEventListener('touchend', onUp);

                taskBar.addEventListener('click', function(e){
                    const clientX = e.clientX || (e.touches && e.touches[0] && e.touches[0].clientX);
                    updateFromX(clientX);
                });

                // Share handler: builds a simple tweet with stats
                if(shareBtn){
                    shareBtn.addEventListener('click', ()=>{
                        const completed = tasksCompleted.textContent || 0;
                        const co2 = co2Value.textContent || 0;
                        const text = encodeURIComponent(`I completed ${completed} eco-tasks on ReLeaf and helped reduce ${co2} kg CO2! Join me: `);
                        const url = `https://twitter.com/intent/tweet?text=${text}&url=${location.origin}`;
                        window.open(url, '_blank');
                    });
                }
            })();
        });

        /* CSS keyframes injected via landing.css; keep JS focused on behavior */

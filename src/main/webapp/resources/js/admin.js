// Initialize AOS
AOS.init({
    duration: 800,
    once: true,
    offset: 100
});

// Animate stat numbers
document.addEventListener('DOMContentLoaded', () => {
    const stats = document.querySelectorAll('.stat-number');
    
    stats.forEach(stat => {
        const target = parseInt(stat.getAttribute('data-count'));
        let current = 0;
        const increment = target / 50; // Will complete in 50 steps
        const timer = setInterval(() => {
            current += increment;
            stat.textContent = Math.round(current);
            if (current >= target) {
                stat.textContent = target;
                clearInterval(timer);
            }
        }, 30);
    });
});

// Add hover effects to quick action buttons
const buttons = document.querySelectorAll('.btn');
buttons.forEach(btn => {
    btn.addEventListener('mouseover', () => {
        btn.style.transform = 'translateY(-5px)';
    });
    btn.addEventListener('mouseout', () => {
        btn.style.transform = 'translateY(0)';
    });
});

// Smooth scroll for navigation links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        document.querySelector(this.getAttribute('href')).scrollIntoView({
            behavior: 'smooth'
        });
    });
});

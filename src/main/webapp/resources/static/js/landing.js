// Initialize GSAP ScrollTrigger
gsap.registerPlugin(ScrollTrigger, ScrollToPlugin);

// Remove preload class after page load
window.addEventListener('load', () => {
    document.body.classList.remove('preload');
});

// Initialize AOS
AOS.init({
    duration: 800,
    once: true,
    offset: 100
});

// Animated counters
const counters = document.querySelectorAll('.counter');
const speed = 200;

counters.forEach(counter => {
    const updateCount = () => {
        const target = parseInt(counter.getAttribute('data-target'));
        const count = parseInt(counter.innerText);
        const increment = target / speed;

        if (count < target) {
            counter.innerText = Math.ceil(count + increment);
            setTimeout(updateCount, 1);
        } else {
            counter.innerText = target;
        }
    };
    
    // Start counting when element is in view
    ScrollTrigger.create({
        trigger: counter,
        start: "top 80%",
        onEnter: updateCount
    });
});

// Floating leaves animation
const createLeaf = () => {
    const leaf = document.createElement('div');
    leaf.classList.add('leaf');
    leaf.style.left = Math.random() * 100 + 'vw';
    leaf.style.animationDuration = Math.random() * 3 + 2 + 's';
    leaf.style.opacity = Math.random() * 0.5 + 0.5;
    
    document.querySelector('.floating-leaves').appendChild(leaf);
    
    setTimeout(() => {
        leaf.remove();
    }, 5000);
};

setInterval(createLeaf, 300);

// Impact section interactive slider
const progressBar = document.querySelector('.progress');
const tasksCompleted = document.querySelector('.tasks-completed');
const co2Reduced = document.querySelector('.co2-reduced');
let isDragging = false;

const updateProgress = (e) => {
    const rect = progressBar.parentElement.getBoundingClientRect();
    const x = e.type.includes('touch') ? 
        e.touches[0].clientX - rect.left : 
        e.clientX - rect.left;
    const percent = Math.min(Math.max(x / rect.width * 100, 0), 100);
    
    progressBar.style.width = percent + '%';
    const tasks = Math.round(percent / 100 * 72);
    const co2 = Math.round(tasks * 2.5);
    
    tasksCompleted.textContent = tasks;
    co2Reduced.textContent = co2;
};

progressBar.parentElement.addEventListener('mousedown', (e) => {
    isDragging = true;
    updateProgress(e);
});

progressBar.parentElement.addEventListener('touchstart', (e) => {
    isDragging = true;
    updateProgress(e);
});

window.addEventListener('mousemove', (e) => {
    if (isDragging) updateProgress(e);
});

window.addEventListener('touchmove', (e) => {
    if (isDragging) updateProgress(e);
});

window.addEventListener('mouseup', () => {
    isDragging = false;
});

window.addEventListener('touchend', () => {
    isDragging = false;
});

// Share impact functionality
const shareImpact = () => {
    const tasks = tasksCompleted.textContent;
    const co2 = co2Reduced.textContent;
    const text = `I've completed ${tasks} eco-tasks on ReLeaf, reducing ${co2}kg of CO₂! Join me in making a difference: [Your App URL]`;
    
    if (navigator.share) {
        navigator.share({
            title: 'My ReLeaf Impact',
            text: text,
            url: window.location.href
        }).catch(console.error);
    } else {
        // Fallback copy to clipboard
        navigator.clipboard.writeText(text)
            .then(() => alert('Impact stats copied to clipboard!'))
            .catch(console.error);
    }
};

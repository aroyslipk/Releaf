// Remove preload class once the page has loaded
window.addEventListener('load', () => {
    document.body.classList.remove('preload');
    // Initial animation for the entire page
    gsap.from('body > *', {
        opacity: 0,
        y: 30,
        duration: 1,
        stagger: 0.2,
        ease: 'power2.out'
    });
});

// Initialize GSAP ScrollTrigger and additional plugins
gsap.registerPlugin(ScrollTrigger, ScrollToPlugin);

// Hero section animations
gsap.from('.hero-content', {
    opacity: 0,
    y: 100,
    duration: 1,
    scrollTrigger: {
        trigger: '.hero',
        start: 'top center',
        end: 'bottom center',
        toggleActions: 'play none none reverse'
    }
});

// Animate eco badges
gsap.from('.eco-badges .badge-item', {
    scale: 0,
    opacity: 0,
    duration: 0.5,
    stagger: 0.2,
    scrollTrigger: {
        trigger: '.features',
        start: 'top center+=100',
        toggleActions: 'play none none reverse'
    }
});

// Feature cards stagger animation
gsap.from('.feature-card', {
    opacity: 0,
    y: 50,
    duration: 0.8,
    stagger: 0.2,
    scrollTrigger: {
        trigger: '.features-grid',
        start: 'top center+=100',
        toggleActions: 'play none none reverse'
    }
});

// Circle card special animation
gsap.from('.circle-card', {
    opacity: 0,
    scale: 0.8,
    rotation: -10,
    duration: 1,
    scrollTrigger: {
        trigger: '.features-grid',
        start: 'center center',
        toggleActions: 'play none none reverse'
    }
});

// Mission section parallax effect
gsap.to('.mission-content', {
    y: -50,
    scrollTrigger: {
        trigger: '.mission',
        start: 'top bottom',
        end: 'bottom top',
        scrub: 1
    }
});

// Impact section interactive elements
gsap.from('#task-bar', {
    scaleX: 0,
    duration: 1,
    scrollTrigger: {
        trigger: '#stats',
        start: 'top center+=100',
        toggleActions: 'play none none reverse'
    }
});

// Stats counter animation
gsap.from('.stat-item', {
    opacity: 0,
    y: 30,
    duration: 0.8,
    stagger: 0.2,
    scrollTrigger: {
        trigger: '.hero-stats',
        start: 'top center+=150',
        toggleActions: 'play none none reverse'
    }
});

// Floating leaves animation in hero section
const leaves = document.querySelectorAll('.leaf');
leaves.forEach((leaf, index) => {
    gsap.to(leaf, {
        y: 'random(-20, 20)',
        x: 'random(-20, 20)',
        rotation: 'random(-45, 45)',
        duration: 'random(2, 4)',
        repeat: -1,
        yoyo: true,
        ease: 'sine.inOut',
        delay: index * 0.3
    });
});

// Handle task bar interaction
const taskBar = document.getElementById('task-bar');
const taskFill = document.getElementById('task-fill');
const taskHandle = document.getElementById('task-handle');
const tasksCompleted = document.getElementById('tasks-completed');
const co2Value = document.getElementById('co2-value');
const totalTasks = 72;
const co2PerTask = 2.5; // kg CO2 per task

let isDragging = false;
let startX, startLeft;

function updateProgress(e) {
    const rect = taskBar.getBoundingClientRect();
    let x = (e.type === 'mousemove' ? e.clientX : e.touches[0].clientX) - rect.left;
    x = Math.max(0, Math.min(x, rect.width));
    
    const progress = x / rect.width;
    const tasks = Math.round(progress * totalTasks);
    const co2 = (tasks * co2PerTask).toFixed(2);
    
    taskFill.style.width = `${progress * 100}%`;
    taskHandle.style.left = `${progress * 100}%`;
    tasksCompleted.textContent = tasks;
    co2Value.textContent = co2;
}

// Mouse events
taskHandle.addEventListener('mousedown', e => {
    isDragging = true;
    startX = e.clientX;
    startLeft = parseInt(taskHandle.style.left) || 0;
});

document.addEventListener('mousemove', e => {
    if (!isDragging) return;
    e.preventDefault();
    updateProgress(e);
});

document.addEventListener('mouseup', () => isDragging = false);

// Touch events
taskHandle.addEventListener('touchstart', e => {
    isDragging = true;
    startX = e.touches[0].clientX;
    startLeft = parseInt(taskHandle.style.left) || 0;
});

document.addEventListener('touchmove', e => {
    if (!isDragging) return;
    updateProgress(e);
});

document.addEventListener('touchend', () => isDragging = false);

// Share impact button
document.getElementById('share-impact')?.addEventListener('click', () => {
    const tasks = tasksCompleted.textContent;
    const co2 = co2Value.textContent;
    const text = `I've completed ${tasks} eco-tasks and reduced ${co2}kg of CO₂ with ReLeaf! 🌱 Join me in making a difference!`;
    
    if (navigator.share) {
        navigator.share({
            title: 'My ReLeaf Impact',
            text: text,
            url: window.location.href
        }).catch(console.error);
    } else {
        // Fallback - copy to clipboard
        navigator.clipboard.writeText(text)
            .then(() => alert('Impact stats copied to clipboard!'))
            .catch(console.error);
    }
});

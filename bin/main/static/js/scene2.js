const scene = {
    rotation: { x: 0, y: 0 },
    mouse: { x: 0, y: 0, down: false },
    touch: { x: 0, y: 0, down: false },
    speed: { rotation: 0.5 },
    momentum: { x: 0, y: 0 },
    friction: 0.95
};

function initScene() {
    // Mouse controls
    document.addEventListener('mousedown', (e) => {
        scene.mouse.down = true;
        scene.mouse.x = e.clientX;
        scene.mouse.y = e.clientY;
    });

    document.addEventListener('mousemove', (e) => {
        if (scene.mouse.down) {
            const deltaX = e.clientX - scene.mouse.x;
            const deltaY = e.clientY - scene.mouse.y;
            
            scene.momentum.x = deltaX * scene.speed.rotation;
            scene.momentum.y = deltaY * scene.speed.rotation;
            
            scene.rotation.y += scene.momentum.x;
            scene.rotation.x -= scene.momentum.y;
            
            scene.mouse.x = e.clientX;
            scene.mouse.y = e.clientY;
        }
    });

    document.addEventListener('mouseup', () => {
        scene.mouse.down = false;
    });

    // Touch controls
    document.addEventListener('touchstart', (e) => {
        e.preventDefault();
        scene.touch.down = true;
        scene.touch.x = e.touches[0].clientX;
        scene.touch.y = e.touches[0].clientY;
    });

    document.addEventListener('touchmove', (e) => {
        e.preventDefault();
        if (scene.touch.down) {
            const deltaX = e.touches[0].clientX - scene.touch.x;
            const deltaY = e.touches[0].clientY - scene.touch.y;
            
            scene.momentum.x = deltaX * scene.speed.rotation;
            scene.momentum.y = deltaY * scene.speed.rotation;
            
            scene.rotation.y += scene.momentum.x;
            scene.rotation.x -= scene.momentum.y;
            
            scene.touch.x = e.touches[0].clientX;
            scene.touch.y = e.touches[0].clientY;
        }
    });

    document.addEventListener('touchend', () => {
        scene.touch.down = false;
    });

    // Animation loop
    function animate() {
        // Apply momentum and friction
        if (!scene.mouse.down && !scene.touch.down) {
            scene.momentum.x *= scene.friction;
            scene.momentum.y *= scene.friction;
            scene.rotation.y += scene.momentum.x;
            scene.rotation.x += scene.momentum.y;
        }

        // Limit rotation
        scene.rotation.x = Math.max(-30, Math.min(30, scene.rotation.x));

        // Apply 3D transforms to sections
        const heroContent = document.querySelector('.hero-content');
        if (heroContent) {
            heroContent.style.transform = `
                perspective(2000px)
                rotateX(${scene.rotation.x}deg)
                rotateY(${scene.rotation.y}deg)
                translateZ(50px)
            `;
        }

        // Animate feature cards with depth
        document.querySelectorAll('.feature-card').forEach((card, index) => {
            const depth = 0.2 + (index * 0.1);
            const xOffset = scene.rotation.y * depth * 2;
            const yOffset = scene.rotation.x * depth * 2;
            
            card.style.transform = `
                translate3d(${xOffset}px, ${yOffset}px, 0)
                rotateX(${scene.rotation.x * depth}deg)
                rotateY(${scene.rotation.y * depth}deg)
                scale(${1 + Math.abs(depth) * 0.1})
            `;
        });

        requestAnimationFrame(animate);
    }

    // Start animation
    animate();

    // Fix button click handling
    document.querySelectorAll('a.cta-button').forEach(button => {
        button.addEventListener('click', (e) => {
            const href = button.getAttribute('href');
            if (href) {
                e.preventDefault();
                window.location.href = href;
            }
        });
    });
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', initScene);

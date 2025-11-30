document.addEventListener('DOMContentLoaded', function() {
    // Get filter elements
    const topicSelect = document.querySelector('#topicFilter');
    const levelSelect = document.querySelector('#levelFilter');
    const filterBtn = document.querySelector('#filterBtn');
    const clearBtn = document.querySelector('#clearBtn');
    const taskRows = document.querySelectorAll('.task-row');

    // Filter function
    function filterTasks() {
        const selectedTopic = topicSelect.value;
        const selectedLevel = levelSelect.value;
        let hasVisibleRows = false;

        taskRows.forEach(row => {
            const topic = row.querySelector('.topic').textContent;
            const level = row.querySelector('.level').textContent;
            
            const topicMatch = selectedTopic === '' || topic === selectedTopic;
            const levelMatch = selectedLevel === '' || level === selectedLevel;

            if (topicMatch && levelMatch) {
                row.classList.remove('filtered-out');
                row.classList.add('filtered-in');
                hasVisibleRows = true;
            } else {
                row.classList.add('filtered-out');
                row.classList.remove('filtered-in');
            }
        });

        // Show no results message if needed
        const noResultsMsg = document.querySelector('.no-results');
        if (noResultsMsg) {
            noResultsMsg.style.display = hasVisibleRows ? 'none' : 'block';
        }
    }

    // Clear filters
    function clearFilters() {
        topicSelect.value = '';
        levelSelect.value = '';
        taskRows.forEach(row => {
            row.classList.remove('filtered-out');
            row.classList.add('filtered-in');
        });
        const noResultsMsg = document.querySelector('.no-results');
        if (noResultsMsg) {
            noResultsMsg.style.display = 'none';
        }
    }

    // Add event listeners
    if (filterBtn) filterBtn.addEventListener('click', filterTasks);
    if (clearBtn) clearBtn.addEventListener('click', clearFilters);
});

<%@ include file="../shared/header.jsp" %>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 mb-0 text-gray-800">GreenVerse Task Management</h1>
        <div>
            <a href="/admin/greenverse/tasks/new" class="btn btn-primary">Create New Task</a>
        </div>
    </div>

    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Task Filters</h6>
        </div>
        <div class="card-body">
            <form method="get" action="/admin/greenverse/tasks" class="row g-3 align-items-center">
                <div class="col-auto">
                    <select name="topic" class="form-select">
                        <option value="">All Topics</option>
                        <c:forEach var="topic" items="${topics}">
                            <option value="${topic}" ${selectedTopic == topic ? 'selected' : ''}>${topic}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-auto">
                    <select name="level" class="form-select">
                        <option value="">All Levels</option>
                        <c:forEach var="level" items="${levels}">
                            <option value="${level}" ${selectedLevel == level ? 'selected' : ''}>${level}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary">Apply Filters</button>
                    <a href="/admin/greenverse/tasks" class="btn btn-secondary">Clear</a>
                </div>
            </form>
        </div>
    </div>

    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">All GreenVerse Tasks (${tasks.size()} total)</h6>
        </div>
        <div class="card-body">
            <c:if test="${empty tasks}">
                <div class="text-center p-5">
                    <h2 class="text-muted">No tasks found.</h2>
                    <a href="/admin/greenverse/tasks/new" class="btn btn-primary">Create Your First Task</a>
                </div>
            </c:if>
            <c:if test="${not empty tasks}">
                <div class="table-responsive">
                    <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Topic</th>
                                <th>Level</th>
                                <th>Description</th>
                                <th>XP</th>
                                <th>Type</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="task" items="${tasks}">
                                <tr>
                                    <td>${task.id}</td>
                                    <td>${task.topic}</td>
                                    <td><span class="badge bg-secondary">${task.level}</span></td>
                                    <td>${task.description}</td>
                                    <td><span class="badge bg-success">${task.xpReward} XP</span></td>
                                    <td><span class="badge bg-info">${task.taskType}</span></td>
                                    <td>
                                        <button onclick="openNotesModal(${task.id}, this.getAttribute('data-desc'))" class="btn btn-sm btn-info" title="Manage Task Notes" data-desc="${task.description}">
                                            <i class="fas fa-book"></i> Guide
                                        </button>
                                        <a href="/admin/greenverse/tasks/edit/${task.id}" class="btn btn-sm btn-warning">Edit</a>
                                        <form method="post" action="/admin/greenverse/tasks/delete/${task.id}" class="d-inline" onsubmit="return confirm('Are you sure you want to delete this task?')">
                                            <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
        </div>
    </div>
</div>

<!-- Simple Notes Modal -->
<div class="modal fade" id="notesModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">
                    <i class="fas fa-book"></i> Task Notes
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="alert alert-info mb-3">
                    <i class="fas fa-info-circle"></i> 
                    <strong>Task:</strong> <span id="modalTaskDescription"></span>
                </div>

                <input type="hidden" id="notesTaskId">
                
                <div class="mb-3">
                    <label for="notesTextarea" class="form-label fw-bold">
                        <i class="fas fa-sticky-note"></i> Notes
                    </label>
                    <p class="text-muted small mb-2">
                        Write any instructions, tips, or guidelines for this task. Users will see this when they open the task.
                    </p>
                    <textarea id="notesTextarea" class="form-control" rows="12" 
                              placeholder="Enter notes for this task... (any language, any format)"></textarea>
                </div>

                <div class="d-flex justify-content-between align-items-center">
                    <small class="text-muted"><i class="fas fa-sync-alt"></i> Auto-saves when you click Save</small>
                    <span id="saveStatus" class="text-success" style="display:none;">
                        <i class="fas fa-check-circle"></i> Saved!
                    </span>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="saveNotesBtn" onclick="saveNotes()">
                    <i class="fas fa-save"></i> Save Notes
                </button>
            </div>
        </div>
    </div>
</div>

<style>
#notesTextarea {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    font-size: 0.95rem;
    line-height: 1.6;
    resize: vertical;
    min-height: 250px;
    border: 2px solid #e5e7eb;
    border-radius: 8px;
    transition: border-color 0.3s;
}

#notesTextarea:focus {
    border-color: #3b82f6;
    box-shadow: 0 0 0 0.2rem rgba(59,130,246,0.15);
}

#saveStatus {
    font-weight: 600;
}
</style>

<script>
let currentTaskId = null;
let notesModalInstance = null;

function openNotesModal(taskId, description) {
    currentTaskId = taskId;
    document.getElementById('notesTaskId').value = taskId;
    document.getElementById('modalTaskDescription').textContent = description;
    document.getElementById('saveStatus').style.display = 'none';
    
    // Load existing notes
    loadNotes(taskId);
    
    // Show modal
    notesModalInstance = new bootstrap.Modal(document.getElementById('notesModal'));
    notesModalInstance.show();
}

function loadNotes(taskId) {
    const url = '/admin/greenverse/tasks/' + taskId + '/guide';
    
    fetch(url)
        .then(response => {
            if (response.ok) return response.json();
            throw new Error('Failed to load notes');
        })
        .then(data => {
            if (data.success && data.guide) {
                document.getElementById('notesTextarea').value = data.guide.notes || '';
            } else {
                document.getElementById('notesTextarea').value = '';
            }
        })
        .catch(error => {
            console.log('No existing notes or error:', error);
            document.getElementById('notesTextarea').value = '';
        });
}

function saveNotes() {
    const taskId = document.getElementById('notesTaskId').value;
    const notes = document.getElementById('notesTextarea').value;
    const saveBtn = document.getElementById('saveNotesBtn');
    const statusEl = document.getElementById('saveStatus');
    
    if (!taskId) {
        alert('Error: Task ID is missing.');
        return;
    }
    
    // Show loading state
    saveBtn.disabled = true;
    saveBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
    statusEl.style.display = 'none';
    
    const url = '/admin/greenverse/tasks/' + taskId + '/guide';
    const formData = new FormData();
    formData.append('notes', notes);
    
    fetch(url, {
        method: 'POST',
        body: formData
    })
    .then(response => {
        if (response.ok) return response.json();
        throw new Error('Server returned error');
    })
    .then(data => {
        if (data.success) {
            statusEl.style.display = 'inline';
            statusEl.innerHTML = '<i class="fas fa-check-circle"></i> Saved!';
            
            // Auto close after 1.5 seconds
            setTimeout(() => {
                if (notesModalInstance) {
                    notesModalInstance.hide();
                }
            }, 1500);
        } else {
            alert('Error saving notes: ' + (data.error || 'Unknown error'));
        }
    })
    .catch(error => {
        console.error('Error saving notes:', error);
        alert('An error occurred while saving notes. Please try again.');
    })
    .finally(() => {
        saveBtn.disabled = false;
        saveBtn.innerHTML = '<i class="fas fa-save"></i> Save Notes';
    });
}
</script>

<%@ include file="../shared/footer.jsp" %>
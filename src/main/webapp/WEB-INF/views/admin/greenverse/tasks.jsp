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
                                        <button onclick="openGuideModal(${task.id}, '${task.description}')" class="btn btn-sm btn-info" title="Manage Task Guide">
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

<!-- Task Guide Management Modal -->
<div class="modal fade" id="guideModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">
                    <i class="fas fa-book"></i> Manage Task Guide
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i> 
                    <strong>Task:</strong> <span id="modalTaskDescription"></span>
                </div>

                <form id="guideForm">
                    <input type="hidden" id="guideTaskId" name="taskId">

                    <!-- Nav Tabs -->
                    <ul class="nav nav-tabs mb-4" role="tablist">
                        <li class="nav-item">
                            <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#stepsTab" type="button">
                                <i class="fas fa-list-ol"></i> Steps
                            </button>
                        </li>
                        <li class="nav-item">
                            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#videoTab" type="button">
                                <i class="fas fa-video"></i> Video
                            </button>
                        </li>
                        <li class="nav-item">
                            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#examplesTab" type="button">
                                <i class="fas fa-images"></i> Examples
                            </button>
                        </li>
                        <li class="nav-item">
                            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tipsTab" type="button">
                                <i class="fas fa-lightbulb"></i> Tips
                            </button>
                        </li>
                    </ul>

                    <!-- Tab Content -->
                    <div class="tab-content">
                        <!-- Steps Tab -->
                        <div class="tab-pane fade show active" id="stepsTab">
                            <h6 class="mb-3">Step-by-Step Instructions</h6>
                            <div id="stepsContainer">
                                <div class="step-input-group mb-3">
                                    <div class="input-group">
                                        <span class="input-group-text">Step 1</span>
                                        <input type="text" class="form-control" name="stepTitle[]" placeholder="Step title (e.g., Prepare materials)">
                                        <textarea class="form-control" name="stepDescription[]" placeholder="Step description" rows="2"></textarea>
                                        <button type="button" class="btn btn-danger" onclick="removeStep(this)">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <button type="button" class="btn btn-success" onclick="addStep()">
                                <i class="fas fa-plus"></i> Add Step
                            </button>
                        </div>

                        <!-- Video Tab -->
                        <div class="tab-pane fade" id="videoTab">
                            <h6 class="mb-3">Video Tutorial</h6>
                            <div class="mb-3">
                                <label class="form-label">Video URL (YouTube, Vimeo, etc.)</label>
                                <input type="url" class="form-control" name="videoUrl" id="videoUrl" 
                                       placeholder="https://www.youtube.com/watch?v=...">
                                <small class="text-muted">Paste the full URL of the video tutorial</small>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Video Title (Optional)</label>
                                <input type="text" class="form-control" name="videoTitle" 
                                       placeholder="How to complete this task">
                            </div>
                            <div id="videoPreview" class="mt-3" style="display: none;">
                                <h6>Preview:</h6>
                                <div class="ratio ratio-16x9">
                                    <iframe id="videoIframe" src="" allowfullscreen></iframe>
                                </div>
                            </div>
                            <button type="button" class="btn btn-primary mt-2" onclick="previewVideo()">
                                <i class="fas fa-eye"></i> Preview Video
                            </button>
                        </div>

                        <!-- Examples Tab -->
                        <div class="tab-pane fade" id="examplesTab">
                            <h6 class="mb-3">Example Submissions</h6>
                            <div class="alert alert-warning">
                                <i class="fas fa-exclamation-triangle"></i>
                                <strong>Note:</strong> Upload clear, high-quality images showing correct task completion
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Upload Example Images</label>
                                <input type="file" class="form-control" id="exampleImages" 
                                       accept="image/*" multiple onchange="previewExamples(this)">
                                <small class="text-muted">You can select multiple images (Max 5MB each)</small>
                            </div>
                            <div id="examplesPreview" class="row g-3 mt-3"></div>
                        </div>

                        <!-- Tips Tab -->
                        <div class="tab-pane fade" id="tipsTab">
                            <h6 class="mb-3">Helpful Tips</h6>
                            <div id="tipsContainer">
                                <div class="tip-input-group mb-3">
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-lightbulb"></i></span>
                                        <textarea class="form-control" name="tips[]" 
                                                  placeholder="Enter a helpful tip..." rows="2"></textarea>
                                        <button type="button" class="btn btn-danger" onclick="removeTip(this)">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <button type="button" class="btn btn-success" onclick="addTip()">
                                <i class="fas fa-plus"></i> Add Tip
                            </button>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" onclick="saveGuide()">
                    <i class="fas fa-save"></i> Save Guide
                </button>
            </div>
        </div>
    </div>
</div>

<style>
.step-input-group, .tip-input-group {
    background: #f8f9fa;
    padding: 1rem;
    border-radius: 8px;
    border: 1px solid #dee2e6;
}

.step-input-group .input-group,
.tip-input-group .input-group {
    flex-wrap: wrap;
}

.step-input-group input,
.step-input-group textarea {
    margin-bottom: 0.5rem;
}

#examplesPreview .example-card {
    position: relative;
    border: 2px solid #dee2e6;
    border-radius: 8px;
    overflow: hidden;
}

#examplesPreview .example-card img {
    width: 100%;
    height: 200px;
    object-fit: cover;
}

#examplesPreview .remove-example {
    position: absolute;
    top: 5px;
    right: 5px;
    background: rgba(220, 53, 69, 0.9);
    color: white;
    border: none;
    border-radius: 50%;
    width: 30px;
    height: 30px;
    cursor: pointer;
}
</style>

<script>
let stepCounter = 1;
let tipCounter = 1;

function openGuideModal(taskId, description) {
    document.getElementById('guideTaskId').value = taskId;
    document.getElementById('modalTaskDescription').textContent = description;
    
    // Load existing guide data
    loadGuideData(taskId);
    
    // Show modal
    const modal = new bootstrap.Modal(document.getElementById('guideModal'));
    modal.show();
}

function loadGuideData(taskId) {
    // Fetch existing guide data from server
    fetch(`/admin/greenverse/tasks/${taskId}/guide`)
        .then(response => response.json())
        .then(data => {
            if (data.success && data.guide) {
                // Populate form with existing data
                populateGuideForm(data.guide);
            }
        })
        .catch(error => {
            console.log('No existing guide data or error:', error);
        });
}

function populateGuideForm(guide) {
    // Populate steps
    if (guide.steps && guide.steps.length > 0) {
        document.getElementById('stepsContainer').innerHTML = '';
        guide.steps.forEach((step, index) => {
            addStep(step.title, step.description);
        });
    }
    
    // Populate video
    if (guide.videoUrl) {
        document.querySelector('[name="videoUrl"]').value = guide.videoUrl;
        document.querySelector('[name="videoTitle"]').value = guide.videoTitle || '';
    }
    
    // Populate tips
    if (guide.tips && guide.tips.length > 0) {
        document.getElementById('tipsContainer').innerHTML = '';
        guide.tips.forEach(tip => {
            addTip(tip);
        });
    }
}

function addStep(title = '', description = '') {
    stepCounter++;
    const container = document.getElementById('stepsContainer');
    const stepDiv = document.createElement('div');
    stepDiv.className = 'step-input-group mb-3';
    stepDiv.innerHTML = `
        <div class="input-group">
            <span class="input-group-text">Step ${stepCounter}</span>
            <input type="text" class="form-control" name="stepTitle[]" 
                   placeholder="Step title" value="${title}">
            <textarea class="form-control" name="stepDescription[]" 
                      placeholder="Step description" rows="2">${description}</textarea>
            <button type="button" class="btn btn-danger" onclick="removeStep(this)">
                <i class="fas fa-trash"></i>
            </button>
        </div>
    `;
    container.appendChild(stepDiv);
}

function removeStep(button) {
    button.closest('.step-input-group').remove();
}

function addTip(tipText = '') {
    tipCounter++;
    const container = document.getElementById('tipsContainer');
    const tipDiv = document.createElement('div');
    tipDiv.className = 'tip-input-group mb-3';
    tipDiv.innerHTML = `
        <div class="input-group">
            <span class="input-group-text"><i class="fas fa-lightbulb"></i></span>
            <textarea class="form-control" name="tips[]" 
                      placeholder="Enter a helpful tip..." rows="2">${tipText}</textarea>
            <button type="button" class="btn btn-danger" onclick="removeTip(this)">
                <i class="fas fa-trash"></i>
            </button>
        </div>
    `;
    container.appendChild(tipDiv);
}

function removeTip(button) {
    button.closest('.tip-input-group').remove();
}

function previewVideo() {
    const videoUrl = document.getElementById('videoUrl').value;
    if (!videoUrl) {
        alert('Please enter a video URL first');
        return;
    }
    
    let embedUrl = '';
    
    // Convert YouTube URL to embed format
    if (videoUrl.includes('youtube.com') || videoUrl.includes('youtu.be')) {
        const videoId = videoUrl.match(/(?:youtube\.com\/watch\?v=|youtu\.be\/)([^&\s]+)/);
        if (videoId) {
            embedUrl = `https://www.youtube.com/embed/${videoId[1]}`;
        }
    }
    // Convert Vimeo URL to embed format
    else if (videoUrl.includes('vimeo.com')) {
        const videoId = videoUrl.match(/vimeo\.com\/(\d+)/);
        if (videoId) {
            embedUrl = `https://player.vimeo.com/video/${videoId[1]}`;
        }
    }
    
    if (embedUrl) {
        document.getElementById('videoIframe').src = embedUrl;
        document.getElementById('videoPreview').style.display = 'block';
    } else {
        alert('Unable to preview this video URL. Please check the format.');
    }
}

function previewExamples(input) {
    const preview = document.getElementById('examplesPreview');
    preview.innerHTML = '';
    
    if (input.files) {
        Array.from(input.files).forEach((file, index) => {
            if (file.type.match('image.*')) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const col = document.createElement('div');
                    col.className = 'col-md-4';
                    col.innerHTML = `
                        <div class="example-card">
                            <img src="${e.target.result}" alt="Example ${index + 1}">
                            <button type="button" class="remove-example" onclick="this.closest('.col-md-4').remove()">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                    `;
                    preview.appendChild(col);
                };
                reader.readAsDataURL(file);
            }
        });
    }
}

function saveGuide() {
    const taskId = document.getElementById('guideTaskId').value;
    const form = document.getElementById('guideForm');
    const formData = new FormData(form);
    
    // Add example images
    const exampleImages = document.getElementById('exampleImages').files;
    for (let i = 0; i < exampleImages.length; i++) {
        formData.append('exampleImages', exampleImages[i]);
    }
    
    // Show loading state
    const saveBtn = event.target;
    saveBtn.disabled = true;
    saveBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
    
    fetch(`/admin/greenverse/tasks/${taskId}/guide`, {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            alert('Guide saved successfully!');
            bootstrap.Modal.getInstance(document.getElementById('guideModal')).hide();
        } else {
            alert('Error: ' + (data.error || 'Failed to save guide'));
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('An error occurred while saving the guide');
    })
    .finally(() => {
        saveBtn.disabled = false;
        saveBtn.innerHTML = '<i class="fas fa-save"></i> Save Guide';
    });
}
</script>

<%@ include file="../shared/footer.jsp" %>
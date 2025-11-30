<%@ include file="shared/header.jsp" %>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 mb-0 text-gray-800">Task Reviews</h1>
        <div>
            <span class="badge bg-warning text-dark me-3">${pendingCount} Pending Review</span>
            <c:if test="${pendingCount > 0}">
                <button id="approveAllBtn" class="btn btn-success btn-sm" onclick="approveAllTasks()">
                    <i class="bi bi-check-all"></i> Approve All
                </button>
            </c:if>
        </div>
    </div>

    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <c:if test="${empty pendingTasks}">
        <div class="card shadow mb-4">
            <div class="card-body text-center p-5">
                <h2 class="text-muted">No Tasks Pending Review</h2>
                <p>All task submissions have been reviewed. Check back later for new submissions.</p>
            </div>
        </div>
    </c:if>

    <div class="row">
        <c:forEach var="userTask" items="${pendingTasks}">
            <div class="col-lg-6 mb-4">
                <div class="card shadow">
                    <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                        <h6 class="m-0 font-weight-bold text-primary">${userTask.user.name} - ${userTask.task.topic}</h6>
                        <span class="badge bg-info text-dark">${userTask.task.xpReward} XP</span>
                    </div>
                    <div class="card-body">
                        <p><strong>Task:</strong> ${userTask.task.description}</p>
                        <p><strong>Submitted:</strong> ${userTask.submittedAt}</p>
                        
                        <c:if test="${not empty userTask.proofImage}">
                            <div class="mb-3">
                                <a href="/user/proof-image/${userTask.proofImage}" target="_blank">
                                    <img src="/user/proof-image/${userTask.proofImage}" alt="Task proof" class="img-fluid rounded">
                                </a>
                            </div>
                        </c:if>

                        <hr>

                        <div class="row">
                            <div class="col-md-6">
                                <form method="post" action="/admin/task-reviews/approve/${userTask.id}">
                                    <div class="mb-3">
                                        <label for="approve-notes-${userTask.id}" class="form-label">Approval Notes (optional):</label>
                                        <textarea name="notes" id="approve-notes-${userTask.id}" class="form-control" rows="2" placeholder="Add notes for the user..."></textarea>
                                    </div>
                                    <button type="submit" class="btn btn-success w-100" onclick="return confirm('Approve this task submission?')">Approve</button>
                                </form>
                            </div>
                            <div class="col-md-6">
                                <form method="post" action="/admin/task-reviews/reject/${userTask.id}">
                                    <div class="mb-3">
                                        <label for="reject-notes-${userTask.id}" class="form-label">Rejection Notes (required):</label>
                                        <textarea name="notes" id="reject-notes-${userTask.id}" class="form-control" rows="2" required placeholder="Please explain why this submission was rejected..."></textarea>
                                    </div>
                                    <button type="submit" class="btn btn-danger w-100" onclick="return confirm('Reject this task submission?')">Reject</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<%@ include file="shared/footer.jsp" %>

<script>
function approveAllTasks() {
    if (!confirm('Are you sure you want to approve ALL pending tasks? This action cannot be undone.')) {
        return;
    }

    const btn = document.getElementById('approveAllBtn');
    const originalText = btn.innerHTML;
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Processing...';

    fetch('/admin/task-reviews/approve-all', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showAlert('success', 'Success! ' + data.message);
            setTimeout(() => location.reload(), 1500);
        } else {
            showAlert('danger', 'Error: ' + (data.error || 'Unknown error'));
            btn.disabled = false;
            btn.innerHTML = originalText;
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showAlert('danger', 'An error occurred while approving tasks');
        btn.disabled = false;
        btn.innerHTML = originalText;
    });
}

function showAlert(type, message) {
    const alertDiv = document.createElement('div');
    alertDiv.className = 'alert alert-' + type + ' alert-dismissible fade show';
    alertDiv.setAttribute('role', 'alert');
    alertDiv.innerHTML = message + '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>';
    
    const container = document.querySelector('.container-fluid');
    container.insertBefore(alertDiv, container.firstChild);
}
</script>
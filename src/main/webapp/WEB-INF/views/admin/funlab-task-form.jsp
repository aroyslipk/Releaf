<%@ include file="shared/header.jsp" %>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 mb-0 text-gray-800">${not empty task ? 'Edit' : 'Create'} FunLab Task</h1>
        <a href="/admin/funlab" class="btn btn-secondary">Back to FunLab</a>
    </div>

    <div class="card shadow mb-4">
        <div class="card-header py-3 bg-primary text-white">
            <h6 class="m-0 font-weight-bold">FunLab Task Details</h6>
        </div>
        <div class="card-body">
            <form method="post" action="${not empty task ? '/admin/funlab/tasks/update/' : '/admin/funlab/tasks/create'}${not empty task ? task.id : ''}">
                <div class="mb-3">
                    <label for="topic" class="form-label">Topic *</label>
                    <input type="text" id="topic" name="topic" class="form-control" value="${task.topic}" required maxlength="100">
                    <div class="form-text">The topic/category for this Weekly FunLab task</div>
                </div>

                <div class="mb-3">
                    <label for="level" class="form-label">Difficulty Level *</label>
                    <select id="level" name="level" class="form-select" required>
                        <option value="">Select Level</option>
                        <option value="Easy" ${task.level == 'Easy' ? 'selected' : ''}>Easy</option>
                        <option value="Medium" ${task.level == 'Medium' ? 'selected' : ''}>Medium</option>
                        <option value="Hard" ${task.level == 'Hard' ? 'selected' : ''}>Hard</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="description" class="form-label">Task Description *</label>
                    <textarea id="description" name="description" class="form-control" rows="4" required maxlength="500">${task.description}</textarea>
                    <div class="form-text">Describe what the user needs to do to complete this task</div>
                </div>

                <div class="mb-3">
                    <label for="impact" class="form-label">Environmental Impact *</label>
                    <textarea id="impact" name="impact" class="form-control" rows="3" required>${task.impact}</textarea>
                    <div class="form-text">Describe the positive environmental impact of this task</div>
                </div>

                <div class="mb-3">
                    <label for="proofType" class="form-label">Proof Type *</label>
                    <select id="proofType" name="proofType" class="form-select" required>
                        <option value="">Select Proof Type</option>
                        <option value="PHOTO" ${task.proofType == 'PHOTO' ? 'selected' : ''}>Photo</option>
                        <option value="AUDIO" ${task.proofType == 'AUDIO' ? 'selected' : ''}>Audio</option>
                        <option value="VIDEO" ${task.proofType == 'VIDEO' ? 'selected' : ''}>Video</option>
                        <option value="TEXT" ${task.proofType == 'TEXT' ? 'selected' : ''}>Text</option>
                    </select>
                    <div class="form-text">What type of proof the user should submit</div>
                </div>

                <div class="mb-3">
                    <label for="xpReward" class="form-label">XP Reward</label>
                    <input type="number" id="xpReward" name="xpReward" class="form-control" value="${task.xpReward}" min="1" max="100">
                    <div class="form-text">XP points awarded for completing this task (default: 20)</div>
                </div>

                <div class="mt-4">
                    <button type="submit" class="btn btn-primary">${not empty task ? 'Update' : 'Create'} Task</button>
                    <a href="/admin/funlab" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="shared/footer.jsp" %> 
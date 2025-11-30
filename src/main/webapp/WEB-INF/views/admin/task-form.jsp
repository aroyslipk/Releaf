<%@ include file="shared/header.jsp" %>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 mb-0 text-gray-800">${task != null ? 'Edit' : 'Add'} Task</h1>
        <a href="/admin/greenverse/tasks" class="btn btn-secondary">Back to Tasks</a>
    </div>

    <div class="row">
        <div class="col-lg-8">
            <div class="card shadow mb-4">
                <div class="card-header py-3 bg-primary text-white">
                    <h6 class="m-0 font-weight-bold">Task Details</h6>
                </div>
                <div class="card-body">
                    <form method="post" action="${task != null ? '/admin/greenverse/tasks/update/'.concat(task.id) : '/admin/greenverse/tasks/create'}">
                        <div class="mb-3">
                            <label for="topic" class="form-label">Topic</label>
                            <select id="topic" name="topic" class="form-select" required>
                                <option value="">Select Topic</option>
                                <option value="Plastronauts" ${task != null && task.topic == 'Plastronauts' ? 'selected' : ''}>Plastronauts</option>
                                <option value="Aether Shield" ${task != null && task.topic == 'Aether Shield' ? 'selected' : ''}>Aether Shield</option>
                                <option value="Hydronauts" ${task != null && task.topic == 'Hydronauts' ? 'selected' : ''}>Hydronauts</option>
                                <option value="ChronoClimbers" ${task != null && task.topic == 'ChronoClimbers' ? 'selected' : ''}>ChronoClimbers</option>
                                <option value="Verdantra" ${task != null && task.topic == 'Verdantra' ? 'selected' : ''}>Verdantra</option>
                                <option value="TerraFixers" ${task != null && task.topic == 'TerraFixers' ? 'selected' : ''}>TerraFixers</option>
                                <option value="SmogSmiths" ${task != null && task.topic == 'SmogSmiths' ? 'selected' : ''}>SmogSmiths</option>
                                <option value="EcoMentors" ${task != null && task.topic == 'EcoMentors' ? 'selected' : ''}>EcoMentors</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="level" class="form-label">Difficulty Level</label>
                            <select id="level" name="level" class="form-select" required>
                                <option value="">Select Level</option>
                                <option value="Easy" ${task != null && task.level == 'Easy' ? 'selected' : ''}>Easy</option>
                                <option value="Medium" ${task != null && task.level == 'Medium' ? 'selected' : ''}>Medium</option>
                                <option value="Hard" ${task != null && task.level == 'Hard' ? 'selected' : ''}>Hard</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="description" class="form-label">Task Description</label>
                            <textarea id="description" name="description" class="form-control" required placeholder="Enter a clear and actionable task description...">${task != null ? task.description : ''}</textarea>
                        </div>
                        <div class="mt-4">
                            <button type="submit" class="btn btn-primary">${task != null ? 'Update' : 'Create'} Task</button>
                            <a href="/admin/greenverse/tasks" class="btn btn-secondary">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="card shadow mb-4">
                <div class="card-header py-3 bg-primary text-white">
                    <h6 class="m-0 font-weight-bold">Task Guidelines</h6>
                </div>
                <div class="card-body">
                    <h5>Easy Level</h5>
                    <ul>
                        <li>Simple daily actions</li>
                        <li>Requires minimal time/effort</li>
                        <li>Can be done at home</li>
                        <li>No special equipment needed</li>
                    </ul>
                    <hr>
                    <h5>Medium Level</h5>
                    <ul>
                        <li>Requires planning or preparation</li>
                        <li>May involve others</li>
                        <li>Takes more time/effort</li>
                        <li>Some research may be needed</li>
                    </ul>
                    <hr>
                    <h5>Hard Level</h5>
                    <ul>
                        <li>Community involvement</li>
                        <li>Significant time commitment</li>
                        <li>May require coordination</li>
                        <li>Long-term impact focus</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="shared/footer.jsp" %>


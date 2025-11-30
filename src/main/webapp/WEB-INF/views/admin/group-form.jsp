<%@ include file="shared/header.jsp" %>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 mb-0 text-gray-800">${isEdit ? 'Edit' : 'Create'} Group</h1>
        <a href="/admin/groups" class="btn btn-secondary">Back to Groups</a>
    </div>

    <div class="row">
        <div class="col-lg-8">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Group Details</h6>
                </div>
                <div class="card-body">
                    <form action="${isEdit ? '/admin/groups/update/'.concat(group.id) : '/admin/groups/create'}" method="POST">
                        <div class="mb-3">
                            <label for="groupName" class="form-label">Group Name</label>
                            <input type="text" id="groupName" name="groupName" class="form-control" value="${group.groupName}" required>
                        </div>
                        <div class="mb-3">
                            <label for="description" class="form-label">Description</label>
                            <textarea id="description" name="description" class="form-control" rows="4" required>${group.description}</textarea>
                        </div>
                        <div class="mt-4">
                            <button type="submit" class="btn btn-primary">${isEdit ? 'Update' : 'Create'} Group</button>
                            <a href="/admin/groups" class="btn btn-secondary">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Group Guidelines</h6>
                </div>
                <div class="card-body">
                    <h5 class="card-title">Best Practices</h5>
                    <ul>
                        <li>Choose descriptive and motivating group names.</li>
                        <li>Provide clear descriptions of the group's purpose.</li>
                        <li>Consider organizing groups by location, interests, or skill level.</li>
                        <li>Groups can help users collaborate on challenges.</li>
                        <li>Use groups to foster community and friendly competition.</li>
                    </ul>
                    <hr>
                    <h5 class="card-title">Group Examples</h5>
                    <ul class="list-group">
                        <li class="list-group-item"><strong>Eco Warriors:</strong> For users passionate about environmental activism.</li>
                        <li class="list-group-item"><strong>Green Beginners:</strong> For new users starting their eco journey.</li>
                        <li class="list-group-item"><strong>City Cleaners:</strong> For users focused on urban environmental issues.</li>
                        <li class="list-group-item"><strong>Climate Champions:</strong> For users tackling climate change challenges.</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="shared/footer.jsp" %>


<%@ include file="shared/header.jsp" %>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 mb-0 text-gray-800">${isEdit ? 'Edit' : 'Create New'} Notice</h1>
        <a href="/admin/notices" class="btn btn-secondary">Back to Notices</a>
    </div>

    <div class="row">
        <div class="col-lg-8">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Notice Details</h6>
                </div>
                <div class="card-body">
                    <form action="${isEdit ? '/admin/notices/update/'.concat(notice.id) : '/admin/notices/create'}" method="POST">
                        <div class="mb-3">
                            <label for="title" class="form-label">Notice Title</label>
                            <input type="text" id="title" name="title" class="form-control" value="${notice.title}" required placeholder="Enter a clear and descriptive title">
                        </div>
                        <div class="mb-3">
                            <label for="content" class="form-label">Notice Content</label>
                            <textarea id="content" name="content" class="form-control" rows="6" required placeholder="Enter the full content of your notice...">${notice.content}</textarea>
                        </div>
                        <div class="mt-4">
                            <button type="submit" class="btn btn-primary">${isEdit ? 'Update' : 'Create'} Notice</button>
                            <a href="/admin/notices" class="btn btn-secondary">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Notice Guidelines</h6>
                </div>
                <div class="card-body">
                    <h5 class="card-title">Best Practices</h5>
                    <ul>
                        <li>Use clear, concise titles that summarize the notice.</li>
                        <li>Write content that is easy to understand for all users.</li>
                        <li>Include relevant dates, deadlines, or time-sensitive information.</li>
                        <li>Keep notices positive and motivating.</li>
                        <li>Use proper formatting for better readability.</li>
                    </ul>
                    <hr>
                    <h5 class="card-title">Notice Examples</h5>
                    <ul class="list-group">
                        <li class="list-group-item"><strong>Earth Day Challenge:</strong> Announcing special Earth Day challenges with bonus XP rewards!</li>
                        <li class="list-group-item"><strong>Monthly Leaderboard:</strong> Congratulations to this month's top eco warriors!</li>
                        <li class="list-group-item"><strong>System Maintenance:</strong> Scheduled maintenance window and expected downtime.</li>
                        <li class="list-group-item"><strong>New Features:</strong> Introducing new features and improvements to the platform.</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="shared/footer.jsp" %>


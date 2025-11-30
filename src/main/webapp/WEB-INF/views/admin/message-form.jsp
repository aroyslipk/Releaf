<%@ include file="shared/header.jsp" %>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 mb-0 text-gray-800">Send New Message</h1>
        <a href="/admin/messages" class="btn btn-secondary">Back to Messages</a>
    </div>

    <div class="row">
        <div class="col-lg-8">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Message Details</h6>
                </div>
                <div class="card-body">
                    <form method="post" action="/admin/messages/send">
                        <div class="mb-3">
                            <label for="toUser" class="form-label">Recipient</label>
                            <select id="toUser" name="toUser" class="form-select" required>
                                <option value="">Select a user</option>
                                <c:forEach var="user" items="${users}">
                                    <option value="${user.name}">${user.name} (${user.email})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="subject" class="form-label">Subject</label>
                            <input type="text" id="subject" name="subject" class="form-control" required placeholder="Enter message subject">
                        </div>
                        <div class="mb-3">
                            <label for="body" class="form-label">Message</label>
                            <textarea id="body" name="body" class="form-control" required placeholder="Enter your message..." style="min-height: 200px;"></textarea>
                        </div>
                        <div class="mt-4">
                            <button type="submit" class="btn btn-primary">Send Message</button>
                            <a href="/admin/messages" class="btn btn-secondary">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Message Templates</h6>
                </div>
                <div class="card-body">
                    <div class="list-group">
                        <a href="#" class="list-group-item list-group-item-action" onclick="fillTemplate('Welcome to ReLeaf!', 'Welcome to our eco-friendly community! We\'re excited to have you join us in making a positive impact on the environment. Start by exploring our challenges and earning your first XP points!')">
                            <div class="d-flex w-100 justify-content-between">
                                <h5 class="mb-1">Welcome Message</h5>
                            </div>
                            <p class="mb-1">For new users joining the platform.</p>
                        </a>
                        <a href="#" class="list-group-item list-group-item-action" onclick="fillTemplate('Congratulations on Your Achievement!', 'Congratulations on reaching a new milestone! Your dedication to environmental causes is inspiring. Keep up the great work and continue making a difference!')">
                            <div class="d-flex w-100 justify-content-between">
                                <h5 class="mb-1">Achievement Congratulations</h5>
                            </div>
                            <p class="mb-1">For users who reach milestones.</p>
                        </a>
                        <a href="#" class="list-group-item list-group-item-action" onclick="fillTemplate('New Challenges Available', 'We\'ve added new exciting challenges to the platform! Check out the latest tasks and continue your eco-friendly journey. Every action counts towards a better planet!')">
                            <div class="d-flex w-100 justify-content-between">
                                <h5 class="mb-1">New Challenges</h5>
                            </div>
                            <p class="mb-1">Announcing new tasks or features.</p>
                        </a>
                        <a href="#" class="list-group-item list-group-item-action" onclick="fillTemplate('Monthly Newsletter', 'Here\'s your monthly update from ReLeaf! This month we\'ve seen amazing progress from our community. Thank you for being part of the change!')">
                            <div class="d-flex w-100 justify-content-between">
                                <h5 class="mb-1">Newsletter</h5>
                            </div>
                            <p class="mb-1">Monthly updates and news.</p>
                        </a>
                    </div>
                    <div class="form-text mt-2">Click on any template above to auto-fill the subject and message fields.</div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function fillTemplate(subject, body) {
        document.getElementById('subject').value = subject;
        document.getElementById('body').value = body;
    }
</script>

<%@ include file="shared/footer.jsp" %>


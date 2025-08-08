<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Task Reviews - Admin Dashboard</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <header class="header">
        <div class="header-content">
            <div class="logo">
                <img src="/images/logo.png" alt="ReLeaf Logo">
                <h1>ReLeaf Admin</h1>
            </div>
            <nav>
                <ul class="nav-menu">
                    <li><a href="/admin/dashboard">Dashboard</a></li>
                    <li><a href="/admin/users">Users</a></li>
                    <li><a href="/admin/tasks">Tasks</a></li>
                    <li><a href="/admin/groups">Groups</a></li>
                    <li><a href="/admin/notices">Notices</a></li>
                    <li><a href="/admin/messages">Messages</a></li>
                    <li><a href="/admin/reports">Reports</a></li>
                    <li><a href="/admin/task-reviews" class="active">Task Reviews</a></li>
                </ul>
            </nav>
            <div class="user-info">
                <span>Welcome, Admin</span>
                <a href="/logout" class="logout-btn">Logout</a>
            </div>
        </div>
    </header>

    <main class="main-content">
        <div class="page-header">
            <h1>Task Reviews</h1>
            <div class="header-stats">
                <span class="stat-badge">${pendingCount} Pending Review</span>
            </div>
        </div>

        <c:if test="${not empty success}">
            <div class="alert alert-success">
                ${success}
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-error">
                ${error}
            </div>
        </c:if>

        <c:choose>
            <c:when test="${empty pendingTasks}">
                <div class="card">
                    <div class="card-body" style="text-align: center; padding: 3rem;">
                        <h3 style="color: var(--gray); margin-bottom: 1rem;">No Tasks Pending Review</h3>
                        <p style="color: var(--gray);">All task submissions have been reviewed. Check back later for new submissions.</p>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="task-reviews-grid">
                    <c:forEach var="userTask" items="${pendingTasks}">
                        <div class="review-card">
                            <div class="review-header">
                                <div class="user-info">
                                    <h3>${userTask.user.name}</h3>
                                    <p style="color: var(--gray); margin: 0;">${userTask.user.email}</p>
                                </div>
                                <div class="task-info">
                                    <span class="task-level ${userTask.task.level.toLowerCase()}">${userTask.task.level}</span>
                                    <span class="xp-badge">${userTask.task.xpReward} XP</span>
                                </div>
                            </div>

                            <div class="task-details">
                                <h4 style="color: var(--primary-green); margin-bottom: 0.5rem;">${userTask.task.topic}</h4>
                                <p style="color: var(--dark-gray); margin-bottom: 1rem;">${userTask.task.description}</p>
                                
                                <div class="submission-info">
                                                                         <small style="color: var(--gray);">
                                         Submitted: ${userTask.submittedAt}
                                     </small>
                                </div>
                            </div>

                                                         <div class="proof-section">
                                 <h4 style="margin-bottom: 1rem;">Proof Photo:</h4>
                                 <div class="proof-image-container">
                                     <c:choose>
                                         <c:when test="${not empty userTask.proofImage}">
                                             <img src="/user/proof-image/${userTask.proofImage}" 
                                                  alt="Task proof" 
                                                  class="proof-image"
                                                  onclick="openImageModal('/user/proof-image/${userTask.proofImage}')"
                                                  onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">
                                             <div style="display: none; color: var(--error); padding: 1rem; border: 1px solid var(--error); border-radius: 4px;">
                                                 Proof image not found or could not be loaded.
                                             </div>
                                         </c:when>
                                         <c:otherwise>
                                             <div style="color: var(--gray); padding: 1rem; border: 1px solid var(--light-gray); border-radius: 4px; text-align: center;">
                                                 No proof image provided
                                             </div>
                                         </c:otherwise>
                                     </c:choose>
                                 </div>
                             </div>

                            <div class="review-actions">
                                <form method="post" action="/admin/task-reviews/approve/${userTask.id}" style="display: inline;">
                                    <div class="form-group">
                                        <label for="approve-notes-${userTask.id}" class="form-label">Approval Notes (optional):</label>
                                        <textarea name="notes" id="approve-notes-${userTask.id}" 
                                                  class="form-control" rows="2" 
                                                  placeholder="Add notes for the user..."></textarea>
                                    </div>
                                    <button type="submit" class="btn btn-success" 
                                            onclick="return confirm('Approve this task submission?')">
                                        ✓ Approve
                                    </button>
                                </form>

                                <form method="post" action="/admin/task-reviews/reject/${userTask.id}" style="display: inline;">
                                    <div class="form-group">
                                        <label for="reject-notes-${userTask.id}" class="form-label">Rejection Notes (required):</label>
                                        <textarea name="notes" id="reject-notes-${userTask.id}" 
                                                  class="form-control" rows="2" required
                                                  placeholder="Please explain why this submission was rejected..."></textarea>
                                    </div>
                                    <button type="submit" class="btn btn-error" 
                                            onclick="return confirm('Reject this task submission?')">
                                        ✗ Reject
                                    </button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <!-- Image Modal -->
    <div id="imageModal" class="modal" style="display: none;">
        <div class="modal-content">
            <span class="close" onclick="closeImageModal()">&times;</span>
            <img id="modalImage" src="" alt="Proof Image" style="width: 100%; height: auto;">
        </div>
    </div>

    <style>
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .header-stats {
            display: flex;
            gap: 1rem;
        }

        .stat-badge {
            background: var(--warning);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 500;
        }

        .task-reviews-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 2rem;
        }

        .review-card {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            border: 1px solid var(--light-gray);
        }

        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--light-gray);
        }

        .user-info h3 {
            margin: 0 0 0.25rem 0;
            color: var(--dark-gray);
        }

        .task-info {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            align-items: end;
        }

        .task-details {
            margin-bottom: 1.5rem;
        }

        .submission-info {
            margin-top: 0.5rem;
        }

        .proof-section {
            margin-bottom: 1.5rem;
        }

        .proof-image-container {
            text-align: center;
        }

        .proof-image {
            max-width: 100%;
            max-height: 300px;
            border-radius: 8px;
            border: 2px solid var(--light-gray);
            cursor: pointer;
            transition: transform 0.2s;
        }

        .proof-image:hover {
            transform: scale(1.02);
        }

        .review-actions {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .review-actions form {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .review-actions .form-group {
            margin-bottom: 0.5rem;
        }

        .review-actions .form-control {
            width: 100%;
            padding: 0.5rem;
            border: 1px solid var(--light-gray);
            border-radius: 4px;
            font-size: 0.9rem;
        }

        .review-actions .btn {
            padding: 0.75rem 1rem;
            border: none;
            border-radius: 4px;
            font-weight: 500;
            cursor: pointer;
        }

        .btn-success {
            background: var(--success);
            color: white;
        }

        .btn-error {
            background: var(--error);
            color: white;
        }

        .btn-success:hover {
            background: #28a745;
        }

        .btn-error:hover {
            background: #dc3545;
        }

        /* Image Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.8);
        }

        .modal-content {
            position: relative;
            margin: 5% auto;
            padding: 20px;
            width: 90%;
            max-width: 800px;
            text-align: center;
        }

        .close {
            position: absolute;
            top: 10px;
            right: 25px;
            color: white;
            font-size: 35px;
            font-weight: bold;
            cursor: pointer;
        }

        .close:hover {
            color: #ccc;
        }

        @media (max-width: 768px) {
            .task-reviews-grid {
                grid-template-columns: 1fr;
            }
            
            .review-header {
                flex-direction: column;
                gap: 1rem;
            }
            
            .task-info {
                align-items: start;
            }
        }
    </style>

    <script>
        function openImageModal(imageSrc) {
            document.getElementById('modalImage').src = imageSrc;
            document.getElementById('imageModal').style.display = 'block';
        }

        function closeImageModal() {
            document.getElementById('imageModal').style.display = 'none';
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            var modal = document.getElementById('imageModal');
            if (event.target == modal) {
                closeImageModal();
            }
        }
    </script>
</body>
</html> 
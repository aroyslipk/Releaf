<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Greenverse Tasks - ReLeaf</title>

<!-- Fonts -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">

<!-- Icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">

<!-- Stylesheets -->
<link rel="stylesheet" href="<c:url value='/css/modern-admin.css'/>">
<link rel="stylesheet" href="<c:url value='/css/greenverse-tasks.css'/>">

</head>
<body>
<%@ include file="/WEB-INF/views/common/user-header.jsp" %>

<main class="main-content">
<div class="page-header" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
<h1><i class="fas fa-globe-americas" style="margin-right: 12px;"></i>Greenverse Tasks</h1>
<a href="/user/tasks" class="btn-back-tasks"><i class="fas fa-arrow-left"></i> Back to Tasks</a>
</div>
<style>
.btn-back-tasks {
    background: linear-gradient(135deg, #2D7A48, #358856);
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 25px;
    font-size: 0.9rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 4px 12px rgba(45, 122, 72, 0.25);
    display: inline-flex;
    align-items: center;
    gap: 8px;
    text-decoration: none;
}
.btn-back-tasks:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 16px rgba(45, 122, 72, 0.35);
    background: linear-gradient(135deg, #358856, #3d9960);
    color: white;
}
</style>

<!-- Stats Section -->
<section class="stats-grid">
    <div class="stat-card">
        <div class="stat-icon-wrapper">
            <i class="fas fa-check-double animated-icon"></i>
        </div>
        <div class="stat-info">
            <p>Completed Tasks</p>
            <h3 class="stat-number" data-target="${completedTasks}">0</h3>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon-wrapper">
            <i class="fas fa-dot-circle animated-icon"></i>
        </div>
        <div class="stat-info">
            <p>Current Task</p>
            <c:if test="${not empty lastSubmittedTask}">
                <div style="font-size:13px;line-height:1.4;color:#2d5f3f;">
                    <strong>${lastSubmittedTask.task.topic}</strong><br/>
                    <span style="font-size:12px;color:#666;">→ ${fn:toLowerCase(lastSubmittedTask.task.level)} task</span><br/>
                    <span style="font-size:11px;color:#999;">${lastSubmittedTask.task.description}</span>
                </div>
            </c:if>
            <c:if test="${empty lastSubmittedTask}">
                <div style="font-size:13px;color:#999;">No tasks submitted yet</div>
            </c:if>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon-wrapper">
            <i class="fas fa-list-check animated-icon"></i>
        </div>
        <div class="stat-info">
            <p>Available Tasks</p>
            <h3 class="stat-number" data-target="${topicsAvailable * 9}">0</h3>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon-wrapper">
            <i class="fas fa-trophy animated-icon"></i>
        </div>
        <div class="stat-info">
            <p>Total XP</p>
            <h3 class="stat-number" data-target="${user.xpPoints}">0</h3>
        </div>
    </div>
</section>

<!-- Topics Container -->
<section class="topics-container">
<c:set var="topicIcons" value="fa-seedling,fa-shield-alt,fa-tint,fa-hourglass-half,fa-tree,fa-cogs,fa-smog,fa-chalkboard-teacher" />
<c:set var="topicIconsArray" value="${fn:split(topicIcons, ',')}" />

<c:forEach var="progress" items="${progressList}" varStatus="loop">
<div class="topic-card ${progress.topic eq currentTopic.topic ? 'current' : ''} ${!progress.isUnlocked ? 'locked' : ''}">
<c:if test="${!progress.isUnlocked}">
<div class="locked-overlay" title="Unlock by completing previous challenges.">
<i class="fas fa-lock"></i>
</div>
</c:if>
<div class="topic-header">
    <div class="topic-title">
        <i class="fas ${topicIconsArray[loop.index % fn:length(topicIconsArray)]} topic-mascot"></i>
        ${progress.topic}
    </div>
<div class="topic-summary">
<div class="topic-progress-overview">
<c:set var="topicTaskCount" value="${taskCounts[progress.topic]}" />
<span class="progress-text">
    <c:choose>
        <c:when test="${not empty topicTaskCount}">
            ${progress.easyCompleted + progress.mediumCompleted + progress.hardCompleted} / ${topicTaskCount.total} Tasks
        </c:when>
        <c:otherwise>
            0 / 0 Tasks
        </c:otherwise>
    </c:choose>
</span>
<div class="progress-bar-container">
    <c:set var="totalCompleted" value="${progress.easyCompleted + progress.mediumCompleted + progress.hardCompleted}" />
    <c:set var="percentage" value="0" />
    <c:if test="${not empty topicTaskCount and topicTaskCount.total > 0}">
        <c:set var="percentage" value="${(totalCompleted / topicTaskCount.total) * 100}" />
    </c:if>
    <div class="progress-bar" style="width: ${percentage}%"></div>
</div>
</div>
<button class="expand-btn"><i class="fas fa-chevron-down"></i></button>
</div>
</div>

<div class="topic-content">
<div class="progress-details">
<div class="progress-item">
<i class="fas fa-leaf" style="color: #28a745;"></i>
<p>Easy: ${progress.easyCompleted} / ${not empty topicTaskCount ? topicTaskCount.easy : 0}</p>
</div>
<div class="progress-item">
<i class="fas fa-mountain" style="color: #ffc107;"></i>
<p>Medium: ${progress.mediumCompleted} / ${not empty topicTaskCount ? topicTaskCount.medium : 0}</p>
</div>
<div class="progress-item">
<i class="fas fa-crown" style="color: #dc3545;"></i>
<p>Hard: ${progress.hardCompleted} / ${not empty topicTaskCount ? topicTaskCount.hard : 0}</p>
</div>
</div>

<div class="difficulty-tabs">
<button class="tab active" data-difficulty="easy" data-topic="${progress.topic}">Easy</button>
<button class="tab ${progress.mediumUnlocked ? '' : 'locked'}" data-difficulty="medium" data-topic="${progress.topic}">Medium</button>
<button class="tab ${progress.hardUnlocked ? '' : 'locked'}" data-difficulty="hard" data-topic="${progress.topic}">Hard</button>
</div>

<div class="tasks-grid-container">
<!-- Tasks grids for each difficulty -->
<div id="easy-tasks-${progress.topic}" class="tasks-grid active" data-topic="${progress.topic}" data-difficulty="easy">
    <c:forEach var="task" items="${availableTasks}">
        <c:if test="${task.topic eq progress.topic and task.level eq 'Easy'}">
            <div class="task-card">
                <c:set var="taskStatus" value="NONE" />
                    <c:forEach var="userTask" items="${userTasks}">
                    <c:if test="${userTask.task.id eq task.id}">
                        <%-- Store the enum name as a String to avoid EL enum coercion errors --%>
                        <c:set var="taskStatus" value="${userTask.status.name()}" />
                    </c:if>
                </c:forEach>
                <c:if test="${taskStatus eq 'APPROVED'}">
                    <div class="task-approved-badge"><i class="fas fa-check"></i></div>
                </c:if>
                <div class="task-status-badge ${fn:toLowerCase(taskStatus)}">${taskStatus}</div>
                <p class="task-description">${task.description}</p>
                <p class="task-xp"><i class="fas fa-star"></i> ${task.xpReward} XP</p>
                <c:choose>
                    <c:when test="${taskStatus eq 'APPROVED'}">
                        <button class="btn btn-primary" disabled>
                            ✓ Completed
                        </button>
                    </c:when>
                    <c:when test="${taskStatus eq 'PENDING_REVIEW'}">
                        <button class="btn btn-primary" disabled>
                            ⏳ Pending Review
                        </button>
                    </c:when>
                    <c:when test="${taskStatus eq 'REJECTED'}">
                        <button class="btn btn-primary" onclick="openTaskModal('${task.id}', '${task.description}', this)">
                            Resubmit
                        </button>
                    </c:when>
                    <c:otherwise>
                        <button class="btn btn-primary" onclick="openTaskModal('${task.id}', '${task.description}', this)">
                            Complete Task
                        </button>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
    </c:forEach>
</div>

<div id="medium-tasks-${progress.topic}" class="tasks-grid" data-topic="${progress.topic}" data-difficulty="medium">
<c:forEach var="task" items="${availableTasks}">
<c:if test="${task.topic eq progress.topic and task.level eq 'Medium'}">
<div class="task-card">
<c:set var="taskStatus" value="NONE" />
<c:forEach var="userTask" items="${userTasks}">
<c:if test="${userTask.task.id eq task.id}">
<!-- Store enum as string -->
<c:set var="taskStatus" value="${userTask.status.name()}" />
</c:if>
</c:forEach>
<c:if test="${taskStatus eq 'APPROVED'}">
    <div class="task-approved-badge"><i class="fas fa-check"></i></div>
</c:if>
<div class="task-status-badge ${fn:toLowerCase(taskStatus)}">${taskStatus}</div>
<p class="task-description">${task.description}</p>
<p class="task-xp"><i class="fas fa-star"></i> ${task.xpReward} XP</p>
<button class="btn btn-primary" onclick="openTaskModal('${task.id}', '${task.description}', this)"
        <c:if test="${taskStatus eq 'PENDING_REVIEW' or taskStatus eq 'APPROVED'}">disabled</c:if>>
    <c:choose>
        <c:when test="${taskStatus eq 'PENDING_REVIEW'}">Pending</c:when>
        <c:when test="${taskStatus eq 'APPROVED'}">Completed</c:when>
        <c:when test="${taskStatus eq 'REJECTED'}">Resubmit</c:when>
        <c:otherwise>Complete Task</c:otherwise>
    </c:choose>
</button>
</div>
</c:if>
</c:forEach>
</div>

<div id="hard-tasks-${progress.topic}" class="tasks-grid" data-topic="${progress.topic}" data-difficulty="hard">
<c:forEach var="task" items="${availableTasks}">
<c:if test="${task.topic eq progress.topic and task.level eq 'Hard'}">
<div class="task-card">
<c:set var="taskStatus" value="NONE" />
<c:forEach var="userTask" items="${userTasks}">
<c:if test="${userTask.task.id eq task.id}">
<c:set var="taskStatus" value="${userTask.status.name()}" />
</c:if>
</c:forEach>
<c:if test="${taskStatus eq 'APPROVED'}">
    <div class="task-approved-badge"><i class="fas fa-check"></i></div>
</c:if>
<div class="task-status-badge ${fn:toLowerCase(taskStatus)}">${taskStatus}</div>
<p class="task-description">${task.description}</p>
<p class="task-xp"><i class="fas fa-star"></i> ${task.xpReward} XP</p>
<button class="btn btn-primary" onclick="openTaskModal('${task.id}', '${task.description}', this)"
        <c:if test="${taskStatus eq 'PENDING_REVIEW' or taskStatus eq 'APPROVED'}">disabled</c:if>>
    <c:choose>
        <c:when test="${taskStatus eq 'PENDING_REVIEW'}">Pending</c:when>
        <c:when test="${taskStatus eq 'APPROVED'}">Completed</c:when>
        <c:when test="${taskStatus eq 'REJECTED'}">Resubmit</c:when>
        <c:otherwise>Complete Task</c:otherwise>
    </c:choose>
</button>
</div>
</c:if>
</c:forEach>
</div>
</div>
</div>
</div>
</c:forEach>
</section>
</main>

<!-- Task Completion Modal -->
<div id="taskModal" class="modal">
<div class="modal-content modal-large">
<div class="modal-header">
<h2 class="modal-title">Complete Task</h2>
<span class="close" onclick="closeTaskModal()">&times;</span>
</div>
<div class="modal-body">
<div class="task-modal-layout">
    <!-- Left Side: Task Guide -->
    <div class="task-guide-section">
        <h3 class="guide-title">📚 How to Complete This Task</h3>
        <p id="taskDescription" class="task-desc"></p>
        
        <!-- Guide Tabs -->
        <div class="guide-tabs">
            <button class="guide-tab active" data-tab="steps">📝 Steps</button>
            <button class="guide-tab" data-tab="video">🎬 Video</button>
            <button class="guide-tab" data-tab="examples">📸 Examples</button>
            <button class="guide-tab" data-tab="tips">💡 Tips</button>
        </div>

        <!-- Guide Content -->
        <div class="guide-content">
            <!-- Steps Tab -->
            <div class="guide-panel active" id="steps-panel">
                <div class="steps-list" id="taskSteps">
                    <div class="step-item">
                        <div class="step-number">1</div>
                        <div class="step-text">
                            <strong>Prepare your materials</strong>
                            <p>Gather everything you need before starting</p>
                        </div>
                    </div>
                    <div class="step-item">
                        <div class="step-number">2</div>
                        <div class="step-text">
                            <strong>Take action</strong>
                            <p>Follow the task requirements carefully</p>
                        </div>
                    </div>
                    <div class="step-item">
                        <div class="step-number">3</div>
                        <div class="step-text">
                            <strong>Capture proof</strong>
                            <p>Take a clear photo showing your completed task</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Video Tab -->
            <div class="guide-panel" id="video-panel">
                <div class="video-container" id="taskVideo">
                    <div class="video-placeholder">
                        <i class="fas fa-play-circle"></i>
                        <p>Video guide coming soon!</p>
                    </div>
                </div>
            </div>

            <!-- Examples Tab -->
            <div class="guide-panel" id="examples-panel">
                <div class="examples-grid" id="taskExamples">
                    <div class="example-card">
                        <div class="example-image">
                            <i class="fas fa-image"></i>
                        </div>
                        <p class="example-caption">Example submission</p>
                    </div>
                </div>
            </div>

            <!-- Tips Tab -->
            <div class="guide-panel" id="tips-panel">
                <div class="tips-list" id="taskTips">
                    <div class="tip-item">
                        <i class="fas fa-lightbulb"></i>
                        <p>Make sure your photo is clear and well-lit</p>
                    </div>
                    <div class="tip-item">
                        <i class="fas fa-lightbulb"></i>
                        <p>Include context in your photo to show the full action</p>
                    </div>
                    <div class="tip-item">
                        <i class="fas fa-lightbulb"></i>
                        <p>Be authentic - we value genuine efforts!</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Right Side: Upload Form -->
    <div class="task-upload-section">
        <h3 class="upload-title">📤 Submit Your Proof</h3>
        <form id="taskForm" method="post" action="<c:url value='/user/complete-task'/>" enctype="multipart/form-data">
            <input type="hidden" id="taskId" name="taskId">
            
            <div class="upload-area" id="uploadArea">
                <div class="upload-icon">
                    <i class="fas fa-cloud-upload-alt"></i>
                </div>
                <p class="upload-text">Drag & Drop your image here</p>
                <p class="upload-subtext">or click to browse</p>
                <input type="file" id="proofImage" name="proofImage" class="file-input" accept="image/*" required>
                <div class="upload-requirements">
                    <small>📋 Max 5MB • JPG, PNG</small>
                </div>
            </div>

            <div class="image-preview" id="imagePreview" style="display: none;">
                <img id="previewImg" src="" alt="Preview">
                <button type="button" class="remove-image" onclick="removeImage()">
                    <i class="fas fa-times"></i> Remove
                </button>
            </div>

            <button type="submit" class="btn btn-submit">
                <i class="fas fa-paper-plane"></i> Submit for Review
            </button>
        </form>
    </div>
</div>
</div>
</div>
</div>

<style>
.modal-large {
    max-width: 1000px;
    width: 95%;
}

.task-modal-layout {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 2rem;
    padding: 1rem;
}

.task-guide-section {
    border-right: 2px solid #e5e7eb;
    padding-right: 2rem;
}

.guide-title {
    font-size: 1.3rem;
    color: #047857;
    margin-bottom: 1rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.task-desc {
    background: #f0fdf4;
    padding: 1rem;
    border-radius: 12px;
    border-left: 4px solid #10b981;
    margin-bottom: 1.5rem;
    color: #374151;
}

.guide-tabs {
    display: flex;
    gap: 0.5rem;
    margin-bottom: 1.5rem;
    flex-wrap: wrap;
}

.guide-tab {
    padding: 0.6rem 1rem;
    border: 2px solid #e5e7eb;
    background: white;
    border-radius: 8px;
    cursor: pointer;
    font-weight: 600;
    font-size: 0.9rem;
    transition: all 0.3s;
}

.guide-tab:hover {
    border-color: #10b981;
    background: #f0fdf4;
}

.guide-tab.active {
    background: #10b981;
    color: white;
    border-color: #10b981;
}

.guide-content {
    position: relative;
    min-height: 300px;
}

.guide-panel {
    display: none;
    animation: fadeIn 0.3s;
}

.guide-panel.active {
    display: block;
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
}

.steps-list {
    display: flex;
    flex-direction: column;
    gap: 1rem;
}

.step-item {
    display: flex;
    gap: 1rem;
    padding: 1rem;
    background: white;
    border-radius: 12px;
    border: 2px solid #e5e7eb;
    transition: all 0.3s;
}

.step-item:hover {
    border-color: #10b981;
    box-shadow: 0 4px 12px rgba(16, 185, 129, 0.1);
}

.step-number {
    width: 40px;
    height: 40px;
    background: linear-gradient(135deg, #10b981, #059669);
    color: white;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 700;
    flex-shrink: 0;
}

.step-text strong {
    color: #047857;
    display: block;
    margin-bottom: 0.3rem;
}

.step-text p {
    color: #6b7280;
    font-size: 0.9rem;
    margin: 0;
}

.video-container {
    background: #f9fafb;
    border-radius: 12px;
    overflow: hidden;
    aspect-ratio: 16/9;
}

.video-placeholder {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 100%;
    color: #9ca3af;
}

.video-placeholder i {
    font-size: 4rem;
    margin-bottom: 1rem;
}

.examples-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 1rem;
}

.example-card {
    border: 2px solid #e5e7eb;
    border-radius: 12px;
    overflow: hidden;
    transition: all 0.3s;
}

.example-card:hover {
    border-color: #10b981;
    transform: translateY(-2px);
}

.example-image {
    aspect-ratio: 4/3;
    background: #f9fafb;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #9ca3af;
    font-size: 2rem;
}

.example-caption {
    padding: 0.5rem;
    text-align: center;
    font-size: 0.85rem;
    color: #6b7280;
    margin: 0;
}

.tips-list {
    display: flex;
    flex-direction: column;
    gap: 1rem;
}

.tip-item {
    display: flex;
    gap: 1rem;
    padding: 1rem;
    background: #fffbeb;
    border-radius: 12px;
    border-left: 4px solid #f59e0b;
}

.tip-item i {
    color: #f59e0b;
    font-size: 1.2rem;
    flex-shrink: 0;
}

.tip-item p {
    margin: 0;
    color: #78350f;
}

.task-upload-section {
    padding-left: 2rem;
}

.upload-title {
    font-size: 1.3rem;
    color: #047857;
    margin-bottom: 1.5rem;
}

.upload-area {
    border: 3px dashed #d1d5db;
    border-radius: 16px;
    padding: 3rem 2rem;
    text-align: center;
    cursor: pointer;
    transition: all 0.3s;
    position: relative;
    background: #f9fafb;
}

.upload-area:hover {
    border-color: #10b981;
    background: #f0fdf4;
}

.upload-area.dragover {
    border-color: #10b981;
    background: #ecfdf5;
    transform: scale(1.02);
}

.upload-icon {
    font-size: 3rem;
    color: #10b981;
    margin-bottom: 1rem;
}

.upload-text {
    font-size: 1.1rem;
    font-weight: 600;
    color: #374151;
    margin-bottom: 0.5rem;
}

.upload-subtext {
    color: #6b7280;
    font-size: 0.9rem;
    margin-bottom: 1rem;
}

.file-input {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    opacity: 0;
    cursor: pointer;
}

.upload-requirements {
    margin-top: 1rem;
    padding-top: 1rem;
    border-top: 1px solid #e5e7eb;
}

.upload-requirements small {
    color: #6b7280;
}

.image-preview {
    margin-top: 1.5rem;
    position: relative;
    border-radius: 12px;
    overflow: hidden;
    border: 2px solid #10b981;
}

.image-preview img {
    width: 100%;
    display: block;
    border-radius: 10px;
}

.remove-image {
    position: absolute;
    top: 10px;
    right: 10px;
    background: rgba(239, 68, 68, 0.9);
    color: white;
    border: none;
    padding: 0.5rem 1rem;
    border-radius: 8px;
    cursor: pointer;
    font-weight: 600;
    transition: all 0.3s;
}

.remove-image:hover {
    background: #dc2626;
}

.btn-submit {
    width: 100%;
    padding: 1.2rem;
    background: linear-gradient(135deg, #10b981, #059669);
    color: white;
    border: none;
    border-radius: 12px;
    font-size: 1.1rem;
    font-weight: 700;
    cursor: pointer;
    margin-top: 1.5rem;
    transition: all 0.3s;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
}

.btn-submit:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 20px rgba(16, 185, 129, 0.3);
}

.btn-submit:disabled {
    background: #9ca3af;
    cursor: not-allowed;
}

@media (max-width: 768px) {
    .task-modal-layout {
        grid-template-columns: 1fr;
    }

    .task-guide-section {
        border-right: none;
        border-bottom: 2px solid #e5e7eb;
        padding-right: 0;
        padding-bottom: 2rem;
    }

    .task-upload-section {
        padding-left: 0;
        padding-top: 2rem;
    }

    .examples-grid {
        grid-template-columns: 1fr;
    }
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
// Count-up animation for stats
const counters = document.querySelectorAll('.stat-number');
const speed = 200; // The lower the slower

counters.forEach(counter => {
const updateCount = () => {
const target = +counter.getAttribute('data-target');
const count = +counter.innerText;
const inc = target / speed;

if (count < target) {
counter.innerText = Math.ceil(count + inc);
setTimeout(updateCount, 1);
} else {
counter.innerText = target;
}
};
updateCount();
});

// Collapsible topic cards
const topicHeaders = document.querySelectorAll('.topic-header');
topicHeaders.forEach(header => {
header.addEventListener('click', () => {
const topicCard = header.closest('.topic-card');
if (!topicCard.classList.contains('locked')) {
topicCard.classList.toggle('expanded');
}
});
});

// Auto-expand last submitted topic (persists across sessions)
// Priority: sessionStorage (just submitted) > lastSubmittedTask (from database) > server data > current topic
const sessionTopic = sessionStorage.getItem('currentTopic');
const sessionDifficulty = sessionStorage.getItem('currentDifficulty');

// Get topic from lastSubmittedTask if available
let taskTopic = null;
let taskDifficulty = null;
<c:if test="${not empty lastSubmittedTask}">
    taskTopic = '${lastSubmittedTask.task.topic}';
    taskDifficulty = '${lastSubmittedTask.task.level}';
</c:if>

// Fallback to user profile data
const serverTopic = '${lastSubmittedTopic}' !== 'null' && '${lastSubmittedTopic}' !== '' ? '${lastSubmittedTopic}' : null;
const serverDifficulty = '${lastSubmittedDifficulty}' !== 'null' && '${lastSubmittedDifficulty}' !== '' ? '${lastSubmittedDifficulty}' : null;

console.log('🔍 Topic Expansion Debug:');
console.log('  Session Topic:', sessionTopic);
console.log('  Session Difficulty:', sessionDifficulty);
console.log('  Task Topic:', taskTopic);
console.log('  Task Difficulty:', taskDifficulty);
console.log('  Server Topic:', serverTopic);
console.log('  Server Difficulty:', serverDifficulty);

// Use session data if available, otherwise use task data, then server data
const savedTopic = sessionTopic || taskTopic || serverTopic;
const savedDifficulty = sessionDifficulty || taskDifficulty || serverDifficulty;

console.log('  ✅ Final Topic:', savedTopic);
console.log('  ✅ Final Difficulty:', savedDifficulty);

const topicCards = document.querySelectorAll('.topic-card');
topicCards.forEach(card => {
    // If we have a saved topic, expand that one instead
    if (savedTopic) {
        const topicTitle = card.querySelector('.topic-title');
        const topicText = topicTitle ? topicTitle.textContent.trim() : '';
        
        console.log('  🔍 Checking card:', topicText, 'vs saved:', savedTopic);
        
        // More robust matching - check if topic names match (case insensitive)
        const topicMatches = topicText.toLowerCase().includes(savedTopic.toLowerCase()) || 
                           savedTopic.toLowerCase().includes(topicText.toLowerCase());
        
        if (topicTitle && topicMatches && !card.classList.contains('locked')) {
            console.log('  ✅ EXPANDING:', topicText);
            card.classList.add('expanded');
            
            // Also activate the saved difficulty tab
            if (savedDifficulty) {
                const tabs = card.querySelectorAll('.difficulty-tabs .tab');
                tabs.forEach(tab => {
                    if (tab.dataset.difficulty === savedDifficulty && !tab.classList.contains('locked')) {
                        tab.classList.add('active');
                        // Show the corresponding task grid
                        const taskGrids = card.querySelectorAll('.tasks-grid');
                        taskGrids.forEach(grid => {
                            if (grid.dataset.difficulty === savedDifficulty) {
                                grid.classList.add('active');
                            } else {
                                grid.classList.remove('active');
                            }
                        });
                    } else {
                        tab.classList.remove('active');
                    }
                });
            }
        } else {
            console.log('  ❌ NOT expanding:', topicText);
            card.classList.remove('expanded');
        }
    } else {
        console.log('  ⚠️ No saved topic, using default behavior');
        // Default behavior: expand current topic
        if (card.classList.contains('current') && !card.classList.contains('locked')) {
            console.log('  ✅ EXPANDING current topic:', card.querySelector('.topic-title')?.textContent.trim());
            card.classList.add('expanded');
        } else {
            card.classList.remove('expanded');
        }
    }
});

// Clear the session storage after restoring (so it doesn't override future page loads)
if (sessionTopic) {
    sessionStorage.removeItem('currentTopic');
    sessionStorage.removeItem('currentDifficulty');
}

// Difficulty tabs
const tabs = document.querySelectorAll('.difficulty-tabs .tab');
tabs.forEach(tab => {
tab.addEventListener('click', (e) => {
e.stopPropagation();
if (tab.classList.contains('locked')) return;

const topicCard = tab.closest('.topic-card');
const topicName = tab.dataset.topic;
const difficulty = tab.dataset.difficulty;

// Update tabs in the current topic card
const tabsInCard = topicCard.querySelectorAll('.difficulty-tabs .tab');
tabsInCard.forEach(t => t.classList.remove('active'));
tab.classList.add('active');

// Update task grids in the current topic card
const taskGrids = topicCard.querySelectorAll('.tasks-grid');
taskGrids.forEach(grid => grid.classList.remove('active'));

// Find target grid by difficulty within the same topic card (more robust)
const targetGrid = topicCard.querySelector(`.tasks-grid[data-difficulty="${difficulty}"]`);
if (targetGrid) {
    targetGrid.classList.add('active');
} else {
    // Fallback: try to match by both attributes in case structure differs
    const fallbackGrids = topicCard.querySelectorAll('.tasks-grid');
    fallbackGrids.forEach(g => {
        if (g.dataset.topic && g.dataset.topic.trim() === topicName && g.dataset.difficulty === difficulty) {
            g.classList.add('active');
        }
    });
}
});
});
});

    let currentTaskButton = null;

    // Modal functions
    function openTaskModal(taskId, description, button) {
        document.getElementById('taskId').value = taskId;
        document.getElementById('taskDescription').innerText = description;
        document.getElementById('taskModal').style.display = 'flex';
        currentTaskButton = button;
        
        // Reset to first tab
        document.querySelectorAll('.guide-tab').forEach(tab => tab.classList.remove('active'));
        document.querySelectorAll('.guide-panel').forEach(panel => panel.classList.remove('active'));
        document.querySelector('.guide-tab[data-tab="steps"]').classList.add('active');
        document.getElementById('steps-panel').classList.add('active');
        
        // Reset upload area
        document.getElementById('imagePreview').style.display = 'none';
        document.getElementById('uploadArea').style.display = 'block';
        document.getElementById('proofImage').value = '';
    }

    function closeTaskModal() {
        document.getElementById('taskModal').style.display = 'none';
        currentTaskButton = null;
    }

    function removeImage() {
        document.getElementById('imagePreview').style.display = 'none';
        document.getElementById('uploadArea').style.display = 'block';
        document.getElementById('proofImage').value = '';
    }

    window.onclick = function(event) {
        if (event.target == document.getElementById('taskModal')) {
            closeTaskModal();
        }
    }

    // Guide tabs functionality
    document.querySelectorAll('.guide-tab').forEach(tab => {
        tab.addEventListener('click', function() {
            const targetTab = this.dataset.tab;
            
            // Remove active class from all tabs and panels
            document.querySelectorAll('.guide-tab').forEach(t => t.classList.remove('active'));
            document.querySelectorAll('.guide-panel').forEach(p => p.classList.remove('active'));
            
            // Add active class to clicked tab and corresponding panel
            this.classList.add('active');
            document.getElementById(targetTab + '-panel').classList.add('active');
        });
    });

    // Drag and drop functionality
    const uploadArea = document.getElementById('uploadArea');
    const fileInput = document.getElementById('proofImage');
    const imagePreview = document.getElementById('imagePreview');
    const previewImg = document.getElementById('previewImg');

    ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
        uploadArea.addEventListener(eventName, preventDefaults, false);
    });

    function preventDefaults(e) {
        e.preventDefault();
        e.stopPropagation();
    }

    ['dragenter', 'dragover'].forEach(eventName => {
        uploadArea.addEventListener(eventName, () => {
            uploadArea.classList.add('dragover');
        }, false);
    });

    ['dragleave', 'drop'].forEach(eventName => {
        uploadArea.addEventListener(eventName, () => {
            uploadArea.classList.remove('dragover');
        }, false);
    });

    uploadArea.addEventListener('drop', function(e) {
        const dt = e.dataTransfer;
        const files = dt.files;
        if (files.length > 0) {
            fileInput.files = files;
            handleFileSelect(files[0]);
        }
    });

    fileInput.addEventListener('change', function(e) {
        if (this.files && this.files[0]) {
            handleFileSelect(this.files[0]);
        }
    });

    function handleFileSelect(file) {
        // Validate file type
        if (!file.type.match('image.*')) {
            alert('Please select an image file (JPG or PNG)');
            return;
        }

        // Validate file size (5MB)
        if (file.size > 5 * 1024 * 1024) {
            alert('File size must be less than 5MB');
            return;
        }

        // Show preview
        const reader = new FileReader();
        reader.onload = function(e) {
            previewImg.src = e.target.result;
            uploadArea.style.display = 'none';
            imagePreview.style.display = 'block';
        };
        reader.readAsDataURL(file);
    }

    document.getElementById('taskForm').addEventListener('submit', function(event) {
        event.preventDefault();

        const form = event.target;
        const formData = new FormData(form);
        const submitButton = form.querySelector('button[type="submit"]');
        submitButton.disabled = true;
        submitButton.textContent = 'Submitting...';

        // Store current topic and difficulty before submitting
        const activeTab = document.querySelector('.difficulty-tabs .tab.active');
        if (activeTab) {
            const currentTopic = activeTab.dataset.topic;
            const currentDifficulty = activeTab.dataset.difficulty;
            sessionStorage.setItem('currentTopic', currentTopic);
            sessionStorage.setItem('currentDifficulty', currentDifficulty);
        }

        fetch(form.action, {
            method: 'POST',
            body: formData
        })
        .then(response => {
            console.log('Response status:', response.status);
            console.log('Response headers:', response.headers.get('content-type'));
            
            if (!response.ok) {
                return response.text().then(text => {
                    console.error('Error response:', text);
                    throw new Error('Server returned ' + response.status + ': ' + text);
                });
            }
            
            return response.json();
        })
        .then(data => {
            console.log('Response data:', data);
            if (data.success) {
                closeTaskModal();
                // Show success message and refresh page after 1.5 seconds
                alert(data.success);
                setTimeout(() => {
                    location.reload();
                }, 1500);
            } else if (data.error) {
                alert('Error: ' + data.error);
            } else {
                alert('Unexpected response from server');
            }
        })
        .catch(error => {
            console.error('Fetch error:', error);
            alert('An unexpected error occurred: ' + error.message);
        })
        .finally(() => {
            submitButton.disabled = false;
            submitButton.innerHTML = '<i class="fas fa-paper-plane"></i> Submit for Review';
        });
    });
</script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="task-card card">
    <div class="task-header">
        <h4 class="task-title">${task.name}</h4>
        <span class="task-xp badge badge-secondary">${task.xpReward} XP</span>
    </div>
    <p class="task-description">${task.description}</p>
    
    <div class="task-footer">
        <c:set var="userTaskStatus" value="NOT_STARTED" />
        <c:forEach var="userTask" items="${userTasks}">
            <c:if test="${userTask.task.id == task.id}">
                <%-- store enum name as String to avoid EL coercion --%>
                <c:set var="userTaskStatus" value="${userTask.status.name()}" />
            </c:if>
        </c:forEach>

        <c:choose>
            <c:when test="${userTaskStatus eq 'COMPLETED'}">
                <span class="badge badge-success"><i class="fas fa-check"></i> Completed</span>
            </c:when>
            <c:when test="${userTaskStatus eq 'PENDING_REVIEW'}">
                <span class="badge badge-warning"><i class="fas fa-clock"></i> Pending Review</span>
            </c:when>
            <c:when test="${userTaskStatus eq 'REJECTED'}">
                <span class="badge badge-danger"><i class="fas fa-times"></i> Rejected</span>
                <button class="btn btn-sm btn-primary" onclick="openTaskModal('${task.id}', '${task.description}')">Resubmit</button>
            </c:when>
            <c:otherwise>
                <button class="btn btn-sm btn-primary" onclick="openTaskModal('${task.id}', '${task.description}')">Complete Task</button>
            </c:otherwise>
        </c:choose>
    </div>
</div>

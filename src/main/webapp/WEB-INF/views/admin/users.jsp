<%@ include file="shared/header.jsp" %>

<div class="container-fluid">
    <h1 class="h3 mb-4 text-gray-800">User Management</h1>

    <div class="row">
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-primary shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Total Users</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">${users.size()}</div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-users fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-success shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Total XP Earned</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <c:set var="totalXP" value="0" />
                                <c:forEach var="user" items="${users}">
                                    <c:set var="totalXP" value="${totalXP + user.xpPoints}" />
                                </c:forEach>
                                ${totalXP}
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-star fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-info shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Tasks Completed</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <c:set var="totalCompleted" value="0" />
                                <c:forEach var="user" items="${users}">
                                    <c:set var="totalCompleted" value="${totalCompleted + user.completedTasks.size()}" />
                                </c:forEach>
                                ${totalCompleted}
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-check-circle fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-warning shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Users in Groups</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <c:set var="usersWithGroups" value="0" />
                                <c:forEach var="user" items="${users}">
                                    <c:if test="${user.group != null}">
                                        <c:set var="usersWithGroups" value="${usersWithGroups + 1}" />
                                    </c:if>
                                </c:forEach>
                                ${usersWithGroups}
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-user-friends fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Registered Users (${users.size()} total)</h6>
        </div>
        <div class="card-body">
            <form action="/admin/users" method="GET" class="d-none d-sm-inline-block form-inline mr-auto ml-md-3 my-2 my-md-0 mw-100 navbar-search">
                <div class="input-group">
                    <input type="text" name="searchName" class="form-control bg-light border-0 small" placeholder="Search for..." value="${param.searchName}">
                    <div class="input-group-append">
                        <button class="btn btn-primary" type="submit">
                            <i class="fas fa-search fa-sm"></i>
                        </button>
                    </div>
                </div>
            </form>
            <div class="table-responsive">
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>XP Points</th>
                            <th>Tasks</th>
                            <th>Group</th>
                            <th>Status</th>
                            <th>Joined</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${users}">
                            <tr>
                                <td>${user.id}</td>
                                <td>${user.name}</td>
                                <td>${user.email}</td>
                                <td><span class="badge bg-success">${user.xpPoints}</span></td>
                                <td>${user.completedTasks.size()}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.group != null}">
                                            <span class="badge bg-info">${user.group.groupName}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">No Group</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.banned}">
                                            <span class="badge bg-danger">Banned</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-success">Active</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${user.createdAt.toLocalDate()}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.banned}">
                                            <button class="btn btn-success btn-sm unban-user-btn" 
                                                    data-user-id="${user.id}" 
                                                    title="Unban this user">
                                                <i class="fas fa-unlock"></i> Unban
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-danger btn-sm ban-user-btn" 
                                                    data-user-id="${user.id}" 
                                                    data-user-name="${user.name}" 
                                                    title="Ban this user">
                                                <i class="fas fa-ban"></i> Ban
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Top Performers</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Rank</th>
                            <th>Name</th>
                            <th>XP Points</th>
                            <th>Completed Tasks</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${users}" varStatus="status" begin="0" end="9">
                            <tr>
                                <td>
                                    <c:choose>
                                        <c:when test="${status.index == 0}"><span style="font-size: 1.5rem; filter: drop-shadow(0 2px 2px rgba(0,0,0,0.3))">&#x1F947;</span></c:when>
                                        <c:when test="${status.index == 1}"><span style="font-size: 1.5rem; filter: drop-shadow(0 2px 2px rgba(0,0,0,0.3))">&#x1F948;</span></c:when>
                                        <c:when test="${status.index == 2}"><span style="font-size: 1.5rem; filter: drop-shadow(0 2px 2px rgba(0,0,0,0.3))">&#x1F949;</span></c:when>
                                        <c:otherwise>${status.index + 1}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${user.name}</td>
                                <td><span class="badge bg-success">${user.xpPoints} XP</span></td>
                                <td>${user.completedTasks.size()}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
console.log('Admin users.jsp script loaded');

// Wait for DOM to be fully loaded
document.addEventListener('DOMContentLoaded', function() {
    console.log('DOM Content Loaded');
    
    // Check if modal and form exist
    var modal = document.getElementById('banModal');
    var form = document.getElementById('banForm');
    console.log('Modal element:', modal);
    console.log('Ban form element:', form);
    
    // Add event listeners to all ban buttons
    var banButtons = document.querySelectorAll('.ban-user-btn');
    console.log('Found', banButtons.length, 'ban buttons');
    
    banButtons.forEach(function(button) {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation(); // Stop event from bubbling up
            var userId = this.getAttribute('data-user-id');
            var userName = this.getAttribute('data-user-name');
            console.log('Ban button clicked - userId:', userId, 'userName:', userName);
            showBanModal(userId, userName);
        });
    });
    
    // Add event listeners to all unban buttons
    var unbanButtons = document.querySelectorAll('.unban-user-btn');
    console.log('Found', unbanButtons.length, 'unban buttons');
    
    unbanButtons.forEach(function(button) {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            var userId = this.getAttribute('data-user-id');
            console.log('Unban button clicked - userId:', userId);
            unbanUser(userId);
        });
    });
});

function showBanModal(userId, userName) {
    console.log('showBanModal called with userId:', userId, 'userName:', userName);
    try {
        var modal = document.getElementById('banModal');
        var userNameElement = document.getElementById('banUserName');
        var form = document.getElementById('banForm');
        var banNoteElement = document.getElementById('banNote');
        
        if (!modal) {
            console.error('Modal element not found!');
            alert('Error: Modal element not found!');
            return;
        }
        if (!userNameElement) {
            console.error('banUserName element not found!');
            return;
        }
        if (!form) {
            console.error('banForm element not found!');
            alert('Error: Form element not found!');
            return;
        }
        
        userNameElement.textContent = userName;
        form.action = '/admin/users/ban/' + userId;
        if (banNoteElement) {
            banNoteElement.value = '';
        }
        
        // Use setTimeout to prevent immediate closing
        setTimeout(function() {
            modal.style.display = 'flex';
            console.log('Modal displayed successfully, action set to:', form.action);
        }, 10);
        
    } catch (error) {
        console.error('Error in showBanModal:', error);
        alert('Error showing ban modal: ' + error.message);
    }
}

function closeBanModal() {
    console.log('closeBanModal called');
    var modal = document.getElementById('banModal');
    if (modal) {
        modal.style.display = 'none';
    }
}

function unbanUser(userId) {
    console.log('unbanUser called with userId:', userId);
    if (confirm('Are you sure you want to unban this user?')) {
        try {
            var form = document.createElement('form');
            form.method = 'POST';
            form.action = '/admin/users/unban/' + userId;
            
            console.log('Unban form action:', form.action);
            
            document.body.appendChild(form);
            console.log('Submitting unban form...');
            form.submit();
        } catch (error) {
            console.error('Error in unbanUser:', error);
            alert('Error unbanning user: ' + error.message);
        }
    }
}

// Close modal when clicking outside (but not on the modal content)
window.addEventListener('click', function(event) {
    var modal = document.getElementById('banModal');
    var modalDialog = document.querySelector('#banModal .modal-dialog');
    
    // Only close if clicking on the dark overlay, not on modal content
    if (event.target === modal && !modalDialog.contains(event.target)) {
        console.log('Closing modal - clicked outside');
        closeBanModal();
    }
});

// Close modal on Escape key
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closeBanModal();
    }
});
</script>

<%@ include file="shared/footer.jsp" %>


<%@ include file="shared/header.jsp" %>

<div class="container-fluid">
    <h1 class="h3 mb-4 text-gray-800">Platform Statistics & Reports</h1>

    <div class="row">
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-primary shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Total Users</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">${totalUsers}</div>
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
                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Total Tasks</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">${totalTasks}</div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-tasks fa-2x text-gray-300"></i>
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
                            <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Completed Tasks</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">${completedTasks}</div>
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
                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Active Tasks</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">${activeTasks}</div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-spinner fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Environmental Impact</h6>
        </div>
        <div class="card-body">
            <div class="row text-center">
                <div class="col-md-3">
                    <h3><i class="bi bi-tree-fill text-success"></i></h3>
                    <h5>Eco Actions</h5>
                    <p class="text-muted">${completedTasks} tasks completed</p>
                </div>
                <div class="col-md-3">
                    <h3><i class="bi bi-globe-americas text-info"></i></h3>
                    <h5>Global Impact</h5>
                    <p class="text-muted">Making change worldwide</p>
                </div>
                <div class="col-md-3">
                    <h3><i class="bi bi-people-fill text-primary"></i></h3>
                    <h5>Community</h5>
                    <p class="text-muted">${totalUsers} eco-warriors</p>
                </div>
                <div class="col-md-3">
                    <h3><i class="bi bi-graph-up-arrow text-warning"></i></h3>
                    <h5>Progress</h5>
                    <p class="text-muted">Growing impact daily</p>
                </div>
            </div>
        </div>
    </div>

    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Export Reports</h6>
        </div>
        <div class="card-body">
            <p>Export functionality will generate CSV files with the selected data for further analysis.</p>
            <a href="/admin/export/users" class="btn btn-primary"><i class="bi bi-download me-2"></i> Export User Data</a>
            <a href="/admin/export/tasks" class="btn btn-primary"><i class="bi bi-download me-2"></i> Export Task Data</a>
            <a href="/admin/export/groups" class="btn btn-primary"><i class="bi bi-download me-2"></i> Export Group Data</a>
            <a href="/admin/export/summary" class="btn btn-info"><i class="bi bi-download me-2"></i> Export Summary Report</a>
        </div>
    </div>
</div>

<script>
    // Helper function for file downloads
    async function downloadReport(url) {
        try {
            const response = await fetch(url);
            if (!response.ok) throw new Error('Export failed');
            
            const blob = await response.blob();
            const filename = response.headers.get('content-disposition')?.split('filename=')[1] || 'report.csv';
            
            const link = document.createElement('a');
            link.href = URL.createObjectURL(blob);
            link.download = filename;
            link.click();
            URL.revokeObjectURL(link.href);
        } catch (error) {
            alert('Failed to export data. Please try again.');
        }
    }

    // Add click handlers to export buttons
    document.querySelectorAll('.btn-primary, .btn-info').forEach(btn => {
        if(btn.href.includes("/admin/export")){
            btn.addEventListener('click', (e) => {
                e.preventDefault();
                downloadReport(btn.href);
            });
        }
    });
</script>

<%@ include file="shared/footer.jsp" %>

    </div>
</div>

<!-- Ban Confirmation Modal - Moved outside wrapper for proper z-index -->
<div class="modal fade" id="banModal" tabindex="-1" role="dialog" aria-labelledby="banModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <form id="banForm" method="post" action="" onsubmit="console.log('Form submitting to:', this.action); return true;">
                <div class="modal-header">
                    <h5 class="modal-title" id="banModalLabel">Ban User</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" onclick="closeBanModal()">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to ban <strong id="banUserName"></strong>?</p>
                    <div class="form-group">
                        <label for="banNote">Reason for ban (optional):</label>
                        <textarea class="form-control" id="banNote" name="banNote" rows="3" placeholder="Enter the reason for banning this user..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeBanModal()">Cancel</button>
                    <button type="submit" class="btn btn-danger">Ban User</button>
                </div>
            </form>
        </div>
    </div>
</div>

<style>
#banModal {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0,0,0,0.5);
    z-index: 99999 !important;
    align-items: center;
    justify-content: center;
}
#banModal .modal-dialog {
    background: white;
    border-radius: 8px;
    max-width: 500px;
    width: 90%;
    margin: auto;
    box-shadow: 0 10px 40px rgba(0,0,0,0.2);
    position: relative;
    z-index: 100000;
}
#banModal .modal-content {
    background: white;
    border-radius: 8px;
}
#banModal .modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 1rem 1.5rem;
    border-bottom: 1px solid #e5e7eb;
    background: white;
}
#banModal .modal-header .close {
    background: none;
    border: none;
    font-size: 1.5rem;
    cursor: pointer;
    color: #666;
    padding: 0;
    width: 30px;
    height: 30px;
    line-height: 1;
}
#banModal .modal-body {
    padding: 1.5rem;
    background: white;
}
#banModal .modal-footer {
    padding: 1rem 1.5rem;
    border-top: 1px solid #e5e7eb;
    display: flex;
    gap: 0.5rem;
    justify-content: flex-end;
    background: white;
}
#banModal textarea {
    width: 100%;
    padding: 0.75rem;
    border: 1px solid #d1d5db;
    border-radius: 6px;
    font-family: inherit;
    font-size: 0.9rem;
    resize: vertical;
}
</style>

</div>
</div>

</body>
</html>

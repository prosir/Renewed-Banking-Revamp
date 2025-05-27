<script lang="ts">
  import { translations } from '../../store/stores';
  import { getContext } from 'svelte';

  export let action = '';
  export let onConfirm = (confirmed) => {};
  
  let title = '';
  let message = '';
  
  $: {
    if (action === 'deleteAccount') {
      title = $translations.delete_account || 'Delete Account';
      message = $translations.delete_account_txt || 'Are you sure you want to delete this account? This action cannot be undone.';
    } else if (action === 'removeMember') {
      title = $translations.remove_member || 'Remove Member';
      message = $translations.remove_member_txt || 'Are you sure you want to remove this member from the account?';
    }
  }
</script>

<div class="fixed inset-0 bg-black bg-opacity-70 flex items-center justify-center z-[60] animate-fadeIn">
  <div class="max-w-[400px] w-full bg-fleeca-bg rounded-lg shadow-card overflow-hidden animate-slideUp">
    <div class="bg-fleeca-card p-4 border-b border-fleeca-border">
      <h3 class="text-lg font-medium text-fleeca-text">{title}</h3>
    </div>
    <div class="p-4">
      <p class="text-fleeca-text-secondary">{message}</p>
    </div>
    
    <div class="bg-fleeca-card p-4 border-t border-fleeca-border flex justify-end space-x-3">
      <button 
        class="py-2 px-4 bg-fleeca-bg text-fleeca-text rounded-md text-sm font-medium hover:bg-fleeca-hover transition-colors border border-fleeca-border"
        on:click={() => onConfirm(false)}
      >
        {$translations.cancel || 'Cancel'}
      </button>
      <button 
        class="py-2 px-4 bg-red-500 text-white rounded-md text-sm font-medium hover:bg-red-600 transition-colors"
        on:click={() => onConfirm(true)}
      >
        {$translations.confirm || 'Confirm'}
      </button>
    </div>
  </div>
</div>

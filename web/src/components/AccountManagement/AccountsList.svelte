<script lang="ts">
  import { translations } from '../../store/stores';
  
  export let accounts = [];
  export let onViewMembers = (account) => {};
  export let onEditAccount = (account) => {};
  export let onDeleteAccount = (account) => {};
</script>

<div class="space-y-4">
  <h3 class="text-lg font-medium text-fleeca-text">{$translations.manage_account || 'Manage Existing Accounts'}</h3>
  
  {#if accounts.length === 0}
    <div class="text-center py-8 bg-fleeca-card rounded-lg border border-fleeca-border animate-fadeIn shadow-card">
      <div class="w-16 h-16 mx-auto bg-fleeca-bg rounded-full flex items-center justify-center mb-4">
        <i class="fas fa-credit-card text-fleeca-text-secondary text-2xl"></i>
      </div>
      <h3 class="text-fleeca-text font-medium">{$translations.no_account || 'No accounts found'}</h3>
      <p class="text-fleeca-text-secondary mt-2">{$translations.no_account_txt || 'You need to be the creator'}</p>
    </div>
  {:else}
    <div class="grid grid-cols-1 gap-4">
      {#each accounts as account}
        <div class="bg-fleeca-card rounded-lg border border-fleeca-border p-4 hover:shadow-card transition-all">
          <div class="flex justify-between items-center mb-3">
            <h4 class="text-fleeca-text font-medium">{account}</h4>
            <div class="flex space-x-2">
              <button 
                class="w-8 h-8 rounded-full bg-fleeca-bg flex items-center justify-center text-fleeca-text-secondary hover:text-fleeca-text transition-colors"
                on:click={() => onViewMembers(account)}
                title={$translations.manage_members || 'Manage Members'}
              >
                <i class="fas fa-users"></i>
              </button>
              <button 
                class="w-8 h-8 rounded-full bg-fleeca-bg flex items-center justify-center text-fleeca-text-secondary hover:text-fleeca-text transition-colors"
                on:click={() => onEditAccount(account)}
                title={$translations.edit_acc_name || 'Change Account Name'}
              >
                <i class="fas fa-edit"></i>
              </button>
              <button 
                class="w-8 h-8 rounded-full bg-fleeca-bg flex items-center justify-center text-red-400 hover:text-red-500 transition-colors"
                on:click={() => onDeleteAccount(account)}
                title={$translations.delete_account || 'Delete Account'}
              >
                <i class="fas fa-trash-alt"></i>
              </button>
            </div>
          </div>
          <div class="text-fleeca-text-secondary text-sm">
            {$translations.account_id || 'Account ID'}: {account}
          </div>
        </div>
      {/each}
    </div>
  {/if}
</div>

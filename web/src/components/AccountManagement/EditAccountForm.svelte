<script lang="ts">
  import { translations } from '../../store/stores';
  
  export let account = '';
  export let onSubmit = (data) => {};
  
  let newName = '';
  
  function handleSubmit() {
    if (newName.trim()) {
      onSubmit({ newName: newName.trim().toLowerCase().replace(/\s+/g, '') });
    }
  }
</script>

<div class="space-y-4">
  <h3 class="text-lg font-medium text-fleeca-text">{$translations.edit_acc_name || 'Change Account Name'}</h3>
  <p class="text-fleeca-text-secondary">{$translations.edit_acc_name_txt || 'Transactions wont update old names'}</p>
  <p class="text-fleeca-text">{$translations.account || 'Account'}: {account}</p>
  
  <div class="bg-fleeca-card rounded-lg border border-fleeca-border p-4">
    <div class="space-y-4">
      <div>
        <label for="newName" class="block text-fleeca-text font-medium mb-1">
          {$translations.account_id || 'Account ID (NO SPACES)'}
        </label>
        <input 
          type="text" 
          id="newName"
          bind:value={newName}
          placeholder="savings-1001"
          class="w-full rounded-lg border border-fleeca-border p-3 bg-fleeca-bg text-fleeca-text focus:border-fleeca-green transition-all"
        />
        <p class="text-fleeca-text-secondary text-sm mt-1">
          {$translations.account_id_hint || 'Use lowercase letters, numbers, and underscores only'}
        </p>
      </div>
      
      <button 
        class="w-full py-3 px-4 bg-fleeca-green text-white rounded-md text-sm font-medium hover:bg-fleeca-dark-green transition-colors"
        on:click={handleSubmit}
      >
        <i class="fas fa-save mr-1"></i> {$translations.change_account_name || 'Change Account Name'}
      </button>
    </div>
  </div>
</div>

<script lang="ts">
  import { translations } from '../../store/stores';
  
  export let onSubmit = (accountId) => {};
  
  let accountId = '';
  
  function handleSubmit() {
    if (accountId.trim()) {
      onSubmit(accountId.trim().toLowerCase().replace(/\s+/g, ''));
    }
  }
</script>

<div class="space-y-4">
  <h3 class="text-lg font-medium text-fleeca-text">{$translations.create_account || 'Create New Account'}</h3>
  <p class="text-fleeca-text-secondary">{$translations.create_account_txt || 'Create a new sub bank account!'}</p>
  
  <div class="bg-fleeca-card rounded-lg border border-fleeca-border p-4">
    <div class="space-y-4">
      <div>
        <label for="accountId" class="block text-fleeca-text font-medium mb-1">
          {$translations.account_id || 'Account ID (NO SPACES)'}
        </label>
        <input 
          type="text" 
          id="accountId"
          bind:value={accountId}
          placeholder="a_test_account"
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
        <i class="fas fa-plus-circle mr-1"></i> {$translations.create_account || 'Create Account'}
      </button>
    </div>
  </div>
</div>

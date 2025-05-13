<script lang="ts">
  import { translations } from '../../store/stores';

  export let account = '';
  export let members = {};
  export let onAddMember = (data) => {};
  export let onRemoveMember = (memberId) => {};

  let newMemberId = '';

  function handleAddMember() {
    if (newMemberId.trim()) {
      onAddMember({ memberId: newMemberId.trim() });
      newMemberId = '';
    }
  }
</script>

<div class="space-y-4">
  <h3 class="text-lg font-medium text-fleeca-text">
    {$translations.manage_members || 'Manage Account Members'}
  </h3>
  <p class="text-fleeca-text-secondary">
    {$translations.account || 'Account'}: {account}
  </p>

  <div class="bg-fleeca-card rounded-lg border border-fleeca-border p-4">
    <h4 class="text-fleeca-text font-medium mb-3">
      {$translations.add_member || 'Add Citizen To Account'}
    </h4>
    <p class="text-fleeca-text-secondary text-sm mb-3">
      {$translations.add_member_txt || 'Be careful who you add (Requires Citizen ID)'}
    </p>

    <div class="flex space-x-2">
      <input 
        type="text" 
        bind:value={newMemberId}
        placeholder={$translations.citizen_id || 'Citizen/State ID'}
        class="flex-1 rounded-lg border border-fleeca-border p-3 bg-fleeca-bg text-fleeca-text focus:border-fleeca-green transition-all"
      />
      <button 
        class="py-3 px-4 bg-fleeca-green text-white rounded-md text-sm font-medium hover:bg-fleeca-dark-green transition-colors"
        on:click={handleAddMember}
      >
        <i class="fas fa-plus mr-1"></i> {$translations.add_member || 'Add Member'}
      </button>
    </div>
  </div>

  <div class="bg-fleeca-card rounded-lg border border-fleeca-border p-4">
    <h4 class="text-fleeca-text font-medium mb-3">
      {$translations.view_members || 'View All Account Members'}
    </h4>

    {#if Object.keys(members).length === 0}
      <div class="text-center py-4">
        <p class="text-fleeca-text-secondary">
          {$translations.no_members || 'No members found'}
        </p>
      </div>
    {:else}
      <div class="space-y-2">
        {#each Object.entries(members) as [memberId, memberName]}
          <div class="flex justify-between items-center p-3 bg-fleeca-bg rounded-lg border border-fleeca-border">
            <div>
              <div class="text-fleeca-text">{memberName}</div>
              <div class="text-fleeca-text-secondary text-sm">{memberId}</div>
            </div>
            <button 
              class="w-8 h-8 rounded-full bg-fleeca-card flex items-center justify-center text-red-400 hover:text-red-500 transition-colors"
              on:click={() => onRemoveMember(memberId)}
              title={$translations.remove_member || 'Remove Member'}
            >
              <i class="fas fa-user-minus"></i>
            </button>
          </div>
        {/each}
      </div>
    {/if}
  </div>
</div>

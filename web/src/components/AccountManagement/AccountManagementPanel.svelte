<script lang="ts">
  import { onMount } from 'svelte';
  import { fetchNui } from '../../utils/fetchNui';
  import { translations, notify } from '../../store/stores';
  import AccountsList from './AccountsList.svelte';
  import AccountMembersList from './AccountMembersList.svelte';
  import CreateAccountForm from './CreateAccountForm.svelte';
  import ConfirmationModal from './ConfirmationModal.svelte';
  import EditAccountForm from './EditAccountForm.svelte';
  import { get } from 'svelte/store';

  export let isVisible = false;
  export let canCreateAccounts = false;
  export let onClose = () => {};
  export let onAccountChange = () => {};

  let activeView = 'main';
  let playerAccounts = [];
  let selectedAccount = null;
  let accountMembers = {};
  let showConfirmation = false;
  let confirmationAction = '';
  let confirmationData = null;

  onMount(() => {
    if (isVisible) {
      fetchPlayerAccounts();
    }
  });

  $: if (isVisible) {
    fetchPlayerAccounts();
  }

  async function fetchPlayerAccounts() {
    try {
      const response = await fetchNui('Renewed-Banking:client:getPlayerAccounts', {}, true);
      if (response && Array.isArray(response)) {
        playerAccounts = response;
      } else {
        playerAccounts = [];
      }
    } catch {
      playerAccounts = [];
    }
  }

  async function viewAccountMembers(account) {
    selectedAccount = account;
    
    try {
      const response = await fetchNui('getMemberManagement', { account });
      
      if (response) {
        accountMembers = response.members || {};
        activeView = 'viewMembers';
      } else {
        accountMembers = {};
        activeView = 'viewMembers';
      }
    } catch (error) {
      accountMembers = {};
      activeView = 'viewMembers';
      notify.set({
        message: get(translations).error_loading_members || "Error loading account members",
        type: "error"
      });
    }
  }

  async function createAccount(accountId) {
    if (!accountId) {
      notify.set({
        message: get(translations).missing_params || "Please provide an account ID",
        type: "error"
      });
      return;
    }

    try {
      await fetchNui('Renewed-Banking:client:createNewAccount', accountId);
      notify.set({
        message: get(translations).account_created || "Account created successfully",
        type: "success"
      });
      fetchPlayerAccounts();
      activeView = 'accountsList';
      onAccountChange();
    } catch {
      notify.set({
        message: get(translations).error_creating_account || "Error creating account",
        type: "error"
      });
    }
  }

  async function addAccountMember(data) {
    if (!data.memberId) {
      notify.set({
        message: get(translations).missing_params || "Please provide a member ID",
        type: "error"
      });
      return;
    }

    try {
      await fetchNui('Renewed-Banking:client:addAccountMember', { 
        account: selectedAccount, 
        memberId: data.memberId 
      });
      notify.set({
        message: get(translations).member_added || "Member added successfully",
        type: "success"
      });
      viewAccountMembers(selectedAccount);
    } catch {
      notify.set({
        message: get(translations).error_adding_member || "Error adding member",
        type: "error"
      });
    }
  }

  async function removeAccountMember(memberId) {
    try {
      await fetchNui('Renewed-Banking:client:removeAccountMember', { 
        account: selectedAccount, 
        cid: memberId 
      });
      notify.set({
        message: get(translations).member_removed || "Member removed successfully",
        type: "success"
      });
      viewAccountMembers(selectedAccount);
    } catch {
      notify.set({
        message: get(translations).error_removing_member || "Error removing member",
        type: "error"
      });
    }
  }

  async function changeAccountName(data) {
    if (!data.newName) {
      notify.set({
        message: get(translations).missing_params || "Please provide a new account name",
        type: "error"
      });
      return;
    }

    try {
      await fetchNui('Renewed-Banking:client:changeAccountName', { 
        account: selectedAccount, 
        newName: data.newName 
      });
      notify.set({
        message: get(translations).account_renamed || "Account renamed successfully",
        type: "success"
      });
      fetchPlayerAccounts();
      activeView = 'accountsList';
      onAccountChange();
    } catch {
      notify.set({
        message: get(translations).error_renaming_account || "Error renaming account",
        type: "error"
      });
    }
  }

  async function deleteAccount() {
    try {
      await fetchNui('Renewed-Banking:client:deleteAccount', { 
        account: selectedAccount 
      });
      notify.set({
        message: get(translations).account_deleted || "Account deleted successfully",
        type: "success"
      });
      fetchPlayerAccounts();
      activeView = 'accountsList';
      onAccountChange();
    } catch {
      notify.set({
        message: get(translations).error_deleting_account || "Error deleting account",
        type: "error"
      });
    }
  }

  function handleConfirmation(action, data = null) {
    confirmationAction = action;
    confirmationData = data;
    showConfirmation = true;
  }

  function confirmAction(confirmed) {
    if (confirmed) {
      if (confirmationAction === 'deleteAccount') {
        deleteAccount();
      } else if (confirmationAction === 'removeMember') {
        removeAccountMember(confirmationData);
      }
    }

    showConfirmation = false;
    confirmationAction = '';
    confirmationData = null;
  }

  function goToMain() {
    activeView = 'main';
  }

  function goToAccountsList() {
    fetchPlayerAccounts();
    activeView = 'accountsList';
  }

  function goToCreateAccount() {
    activeView = 'createAccount';
  }

  function goToEditAccount(account) {
    selectedAccount = account;
    activeView = 'editAccount';
  }
</script>

{#if isVisible}
<div class="fixed inset-0 bg-black bg-opacity-70 flex items-center justify-center z-50 animate-fadeIn">
    <div class="max-w-[800px] w-full bg-fleeca-bg rounded-lg shadow-card overflow-hidden animate-slideUp">
      <div class="bg-fleeca-card p-5 border-b border-fleeca-border">
        <div class="flex justify-between items-center">
          <h2 class="text-xl font-semibold text-fleeca-text font-display flex items-center">
            <div class="w-8 h-8 rounded-lg bg-fleeca-green/10 flex items-center justify-center mr-3 border border-fleeca-green/20">
              <i class="fas fa-users-cog text-fleeca-green"></i>
            </div>
            {get(translations).bank_name || 'Los Santos Banking'} - {get(translations).manage_account || 'Account Management'}
          </h2>
          <button 
            class="w-8 h-8 rounded-full bg-fleeca-bg flex items-center justify-center text-fleeca-text-secondary hover:text-fleeca-text transition-colors"
            on:click={onClose}
          >
            <i class="fa-solid fa-xmark"></i>
          </button>
        </div>
      </div>

      <div class="p-5">
        {#if activeView === 'main'}
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            {#if canCreateAccounts}
              <button 
                class="p-4 bg-fleeca-card rounded-lg border border-fleeca-border hover:bg-fleeca-hover transition-colors flex items-center"
                on:click={goToCreateAccount}
              >
                <div class="w-10 h-10 rounded-full bg-fleeca-green/10 flex items-center justify-center mr-3 border border-fleeca-green/20">
                  <i class="fas fa-plus text-fleeca-green"></i>
                </div>
                <div class="text-left">
                  <h3 class="text-fleeca-text font-medium">{get(translations).create_account || 'Create New Account'}</h3>
                  <p class="text-fleeca-text-secondary text-sm">{get(translations).create_account_txt || 'Create a new sub bank account!'}</p>
                </div>
              </button>
            {/if}

            <button 
              class="p-4 bg-fleeca-card rounded-lg border border-fleeca-border hover:bg-fleeca-hover transition-colors flex items-center"
              on:click={goToAccountsList}
            >
              <div class="w-10 h-10 rounded-full bg-fleeca-green/10 flex items-center justify-center mr-3 border border-fleeca-green/20">
                <i class="fas fa-list text-fleeca-green"></i>
              </div>
              <div class="text-left">
                <h3 class="text-fleeca-text font-medium">{get(translations).manage_account || 'Manage Existing Accounts'}</h3>
                <p class="text-fleeca-text-secondary text-sm">{get(translations).manage_account_txt || 'View existing accounts!'}</p>
              </div>
            </button>
          </div>
        {:else if activeView === 'accountsList'}
          <div class="mb-4">
            <button 
              class="flex items-center text-fleeca-text-secondary hover:text-fleeca-text transition-colors"
              on:click={goToMain}
            >
              <i class="fas fa-arrow-left mr-2"></i>
              {get(translations).back || 'Go Back'}
            </button>
          </div>

          <AccountsList 
            accounts={playerAccounts} 
            onViewMembers={viewAccountMembers}
            onEditAccount={goToEditAccount}
            onDeleteAccount={(account) => {
              selectedAccount = account;
              handleConfirmation('deleteAccount');
            }}
          />
        {:else if activeView === 'createAccount'}
          <div class="mb-4">
            <button 
              class="flex items-center text-fleeca-text-secondary hover:text-fleeca-text transition-colors"
              on:click={goToMain}
            >
              <i class="fas fa-arrow-left mr-2"></i>
              {get(translations).back || 'Go Back'}
            </button>
          </div>

          <CreateAccountForm onSubmit={createAccount} />
        {:else if activeView === 'viewMembers'}
          <div class="mb-4">
            <button 
              class="flex items-center text-fleeca-text-secondary hover:text-fleeca-text transition-colors"
              on:click={goToAccountsList}
            >
              <i class="fas fa-arrow-left mr-2"></i>
              {get(translations).back || 'Go Back'}
            </button>
          </div>

          <AccountMembersList 
            account={selectedAccount}
            members={accountMembers}
            onAddMember={addAccountMember}
            onRemoveMember={(memberId) => handleConfirmation('removeMember', memberId)}
          />
        {:else if activeView === 'editAccount'}
          <div class="mb-4">
            <button 
              class="flex items-center text-fleeca-text-secondary hover:text-fleeca-text transition-colors"
              on:click={goToAccountsList}
            >
              <i class="fas fa-arrow-left mr-2"></i>
              {get(translations).back || 'Go Back'}
            </button>
          </div>

          <EditAccountForm 
            account={selectedAccount}
            onSubmit={changeAccountName}
          />
        {/if}
      </div>
    </div>
  </div>
{/if}

{#if showConfirmation}
  <ConfirmationModal 
    action={confirmationAction}
    onConfirm={confirmAction}
  />
{/if}
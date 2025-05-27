<script lang="ts">
 import { accounts, translations } from "../../store/stores";
 import AccountListItem from "./AccountListItem.svelte";
 import AccountCategorySelector from "./AccountCategorySelector.svelte";
 import { onMount } from "svelte";
 
 let accSearch = "";
 let currentPage = 0;
 let cardsPerPage = 3;
 let selectedCategory = 'all';
 
 function isSpecialOrg(account) {
   if (!account.id || typeof account.id !== 'string') return false;
   
   // Check if account ID contains only letters (and optionally underscores/hyphens)
   // Player CIDs have numbers, organization accounts typically don't
   return /^[a-zA-Z_-]+$/.test(account.id);
 }
 
 $: filteredAccounts = $accounts && Array.isArray($accounts) 
   ? $accounts.filter(item => {
       const matchesSearch = item && item.id && typeof item.id === 'string' && 
         item.id.toLowerCase().includes((accSearch || '').toLowerCase());
       
       const specialOrg = isSpecialOrg(item);
       
       const isOrgByType = item.type && 
         (item.type.toLowerCase() === "org" || item.type.toLowerCase() === "organization");
       
       const isBusiness = !!item.creator;
       
       const isPersonal = !isOrgByType && !isBusiness && !specialOrg;
       
       let matchesCategory = false;
       
       if (selectedCategory === 'all') {
         matchesCategory = true;
       } else if (selectedCategory === 'personal') {
         matchesCategory = isPersonal;
       } else if (selectedCategory === 'business') {
         matchesCategory = isBusiness;
       } else if (selectedCategory === 'org') {
         matchesCategory = (isOrgByType || specialOrg) && !isBusiness;
       }
       
       return matchesSearch && matchesCategory;
     })
   : [];
   
 $: totalPages = Math.ceil(filteredAccounts.length / cardsPerPage);
 
 $: paginatedAccounts = filteredAccounts.slice(
   currentPage * cardsPerPage, 
   (currentPage + 1) * cardsPerPage
 );
 
 $: if (accSearch || selectedCategory) {
   currentPage = 0;
 }
 
 function nextPage() {
   if (currentPage < totalPages - 1) {
     currentPage++;
   }
 }
 
 function prevPage() {
   if (currentPage > 0) {
     currentPage--;
   }
 }
 
 function handleCategoryChange(event) {
   selectedCategory = event.detail;
 }
</script>

<aside class="flex-none w-1/3 overflow-hidden flex flex-col">
 <div class="mb-4">
     <h3 class="text-2xl font-semibold text-fleeca-text mb-4 flex items-center font-display">
         <div class="w-10 h-10 rounded-lg bg-fleeca-card flex items-center justify-center mr-3 border border-fleeca-border">
             <i class="fas fa-credit-card text-fleeca-green"></i>
         </div>
         {$translations.accounts || 'My Cards'}
     </h3>
     
     <AccountCategorySelector 
       selectedCategory={selectedCategory}
       on:categoryChange={handleCategoryChange}
     />
     
     <div class="relative">
         <input 
             type="text" 
             class="w-full rounded-lg border border-fleeca-border p-3 pl-10 bg-fleeca-card text-fleeca-text focus:border-fleeca-green transition-all" 
             placeholder={$translations.account_search || 'Search cards...'} 
             bind:value={accSearch} 
         />
         <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-fleeca-text-secondary"></i>
     </div>
 </div>
 
 <div class="overflow-y-auto flex-1 pr-2 hide-scrollbar">
     {#if filteredAccounts.length > 0}
         <div class="grid grid-cols-1 gap-4 p-2">
             {#each paginatedAccounts as account (account.id)}
                 <AccountListItem {account} />
             {/each}
         </div>
         
         {#if totalPages > 1}
             <div class="flex justify-between items-center mt-4 px-2">
                 <button 
                     class="pagination-btn {currentPage === 0 ? 'disabled' : ''}" 
                     on:click={prevPage}
                     disabled={currentPage === 0}
                 >
                     <i class="fas fa-chevron-left"></i>
                 </button>
                 
                 <span class="text-fleeca-text-secondary text-sm">
                     {currentPage + 1} / {totalPages}
                 </span>
                 
                 <button 
                     class="pagination-btn {currentPage === totalPages - 1 ? 'disabled' : ''}" 
                     on:click={nextPage}
                     disabled={currentPage === totalPages - 1}
                 >
                     <i class="fas fa-chevron-right"></i>
                 </button>
             </div>
         {/if}
     {:else}
         <div class="text-center py-8 bg-fleeca-card rounded-lg border border-fleeca-border animate-fadeIn shadow-card">
             <div class="w-16 h-16 mx-auto bg-fleeca-bg rounded-full flex items-center justify-center mb-4">
                     <i class="fas fa-credit-card text-fleeca-text-secondary text-2xl"></i>
             </div>
             <h3 class="text-fleeca-text font-medium">{$translations && $translations.account_not_found ? $translations.account_not_found : 'No cards found'}</h3>
             {#if selectedCategory !== 'all'}
               <button 
                 class="mt-3 text-fleeca-green hover:text-fleeca-light-green text-sm"
                 on:click={() => selectedCategory = 'all'}
               >
                 <i class="fas fa-sync-alt mr-1"></i>
                 {$translations.show_all || 'Show all accounts'}
               </button>
             {/if}
         </div>
     {/if}
 </div>
</aside>

<style>
 .pagination-btn {
   width: 32px;
   height: 32px;
   border-radius: 50%;
   background-color: var(--fleeca-card);
   border: 1px solid var(--fleeca-border);
   color: var(--fleeca-text);
   display: flex;
   align-items: center;
   justify-content: center;
   transition: all 0.2s;
 }
 
 .pagination-btn:hover:not(.disabled) {
   background-color: var(--fleeca-hover);
   transform: scale(1.05);
 }
 
 .pagination-btn.disabled {
   opacity: 0.5;
   cursor: not-allowed;
 }
</style>
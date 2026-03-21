import 'package:easy_laba/components/drawer.dart';
import 'package:easy_laba/features/user/provider/user_provider.dart';
import 'package:easy_laba/helpers/capitalize_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => AuthGateState();
}

class AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();

    _handleAuth();
  }

  void _handleAuth() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
      if (!mounted) return;

      final userProvider = Provider.of<UserProvider>(context, listen: false);

      final session = data.session;

      if (session == null) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
        return;
      }

      if (mounted) {
        final userData = await Supabase.instance.client
            .from('view_staffs')
            .select("roles, branches")
            .eq('user_id', data.session?.user.id as String)
            .single();

        final userRole = (userData['roles'] as List)
            .map((dynamic role) => role['name'])
            .toList();

        if (userRole.contains('ADMIN')) {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/orders');
          }
        } else {
          final List<Map<String, dynamic>> staffs = await Supabase
              .instance
              .client
              .from('view_staffs')
              .select('user_id, full_name')
              .not('user_id', 'eq', '${userProvider.user?.userId}')
              .contains('branch_ids', '["${userProvider.branchId}"]')
              .order('full_name');

          if (mounted) {
            if (!userProvider.isDoneSelect) {
              final String? result = await showAdaptiveDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => _buildStaffShiftDialog(context, staffs),
              );

              userProvider.setCoWorkerId(result);

              await Supabase.instance.client.rpc(
                'start_staff_shift',
                params: {
                  'p_primary_staff_id': userProvider.user?.userId,
                  'p_branch_id': userProvider.branchId,
                  'p_partner_staff_id': userProvider.coWorkerId,
                },
              );

              if (mounted) {
                Navigator.pushReplacementNamed(context, '/orders');
              }
            } else {
              Navigator.pushReplacementNamed(context, '/orders');
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3B82F6),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Loading...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildStaffShiftDialog(
  BuildContext context,
  List<Map<String, dynamic>> staffs,
) {
  String? coWorkerId;

  return StatefulBuilder(
    builder: (BuildContext stateContext, StateSetter setState) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF3B82F6),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.people_alt_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select Co-Worker',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Choose your shift partner',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Staff List
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Staff (${staffs.length})',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 300),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (_, int i) {
                          final staff = staffs[i];
                          bool isSelected = staff['user_id'] == coWorkerId;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFECFDF5)
                                  : Colors.grey[50],
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF10B981)
                                    : Colors.grey[300]!,
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF10B981,
                                        ).withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              onTap: () => setState(() {
                                coWorkerId = staff['user_id'];
                              }),
                              leading: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundColor: isSelected
                                        ? const Color(0xFF10B981)
                                        : const Color(
                                            0xFF3B82F6,
                                          ).withOpacity(0.1),
                                    child: Text(
                                      (staff['full_name'] as String)
                                          .substring(0, 1)
                                          .toCapitalized(),
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : const Color(0xFF3B82F6),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              title: Text(
                                (staff['full_name'] as String).toCapitalized(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: isSelected
                                      ? const Color(0xFF10B981)
                                      : Colors.grey[800],
                                ),
                              ),
                              trailing: isSelected
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: Color(0xFF10B981),
                                    )
                                  : Icon(
                                      Icons.radio_button_unchecked,
                                      color: Colors.grey[400],
                                    ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemCount: staffs.length,
                      ),
                    ),
                  ],
                ),
              ),
              // Footer Buttons
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: Colors.grey[400]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Work Solo',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: coWorkerId != null
                            ? () => Navigator.of(context).pop(coWorkerId)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          disabledBackgroundColor: Colors.grey[300],
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Confirm Selection',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
